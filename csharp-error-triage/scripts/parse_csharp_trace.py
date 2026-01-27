#!/usr/bin/env python3
import json
import re
import sys
from typing import Any, Dict, List, Optional

STACK_KEY_NAMES = {"stacktrace", "stack_trace"}
EXCEPTION_KEY_NAMES = {"exception", "innerexception", "inner_exception", "innerexceptions"}
EXCEPTION_TYPE_KEYS = (
    "type",
    "exceptiontype",
    "exception_type",
    "classname",
    "name",
)
EXCEPTION_MESSAGE_KEYS = (
    "message",
    "detail",
    "title",
    "reason",
)
FRAME_PENALTY_PREFIXES = (
    "System.",
    "Microsoft.",
    "Temporalio.",
)

FRAME_RE = re.compile(
    r"^\s*at\s+(?P<method>.+?)(?:\s+in\s+(?P<file>.+?):line\s+(?P<line>\d+))?\s*$"
)


def _read_input() -> str:
    if len(sys.argv) > 1 and sys.argv[1] not in {"-", "--"}:
        path = sys.argv[1]
        with open(path, "r", encoding="utf-8") as handle:
            return handle.read()
    if sys.stdin.isatty():
        raise ValueError("No input provided. Pass a file path or pipe content via stdin.")
    return sys.stdin.read()


def _collect_stack_strings(value: Any) -> List[str]:
    stacks: List[str] = []
    if isinstance(value, dict):
        for key, item in value.items():
            key_lower = str(key).lower()
            if key_lower in STACK_KEY_NAMES and isinstance(item, str):
                stacks.append(item)
            else:
                stacks.extend(_collect_stack_strings(item))
    elif isinstance(value, list):
        for item in value:
            stacks.extend(_collect_stack_strings(item))
    return stacks


def _collect_exception_objects(value: Any) -> List[Any]:
    exceptions: List[Any] = []
    if isinstance(value, dict):
        for key, item in value.items():
            key_lower = str(key).lower()
            if key_lower in EXCEPTION_KEY_NAMES:
                exceptions.append(item)
            exceptions.extend(_collect_exception_objects(item))
    elif isinstance(value, list):
        for item in value:
            exceptions.extend(_collect_exception_objects(item))
    return exceptions


def _normalize_exception_entry(value: Any) -> Optional[Dict[str, Optional[str]]]:
    if value is None:
        return None
    if isinstance(value, str):
        return {"type": None, "message": value.strip() or None}
    if not isinstance(value, dict):
        return {"type": None, "message": str(value)}
    exc_type = None
    exc_message = None
    for key, val in value.items():
        key_lower = str(key).lower()
        if exc_type is None and key_lower in EXCEPTION_TYPE_KEYS and isinstance(val, str):
            exc_type = val.strip() or None
        if exc_message is None and key_lower in EXCEPTION_MESSAGE_KEYS and isinstance(val, str):
            exc_message = val.strip() or None
    if exc_type is None and exc_message is None:
        return None
    return {"type": exc_type, "message": exc_message}


def _parse_frames(stack_text: str) -> List[Dict[str, Optional[str]]]:
    frames: List[Dict[str, Optional[str]]] = []
    for line in stack_text.splitlines():
        match = FRAME_RE.match(line)
        if not match:
            continue
        method = match.group("method").strip()
        file_path = match.group("file")
        line_no = match.group("line")
        frames.append(
            {
                "method": method,
                "file": file_path.strip() if file_path else None,
                "line": line_no,
            }
        )
    return frames


def _dedupe_frames(frames: List[Dict[str, Optional[str]]]) -> List[Dict[str, Optional[str]]]:
    seen = set()
    unique: List[Dict[str, Optional[str]]] = []
    for frame in frames:
        key = (frame.get("method"), frame.get("file"), frame.get("line"))
        if key in seen:
            continue
        seen.add(key)
        unique.append(frame)
    return unique


def _primary_frame(frames: List[Dict[str, Optional[str]]]) -> Optional[Dict[str, Optional[str]]]:
    for frame in frames:
        if frame.get("file") and frame.get("line"):
            return frame
    return frames[0] if frames else None


def _score_frame(frame: Dict[str, Optional[str]]) -> int:
    score = 0
    file_path = frame.get("file")
    line_no = frame.get("line")
    method = frame.get("method") or ""
    if file_path and line_no:
        score += 10
    if file_path:
        file_lower = file_path.lower()
        if "/src/" in file_lower or "\\src\\" in file_lower:
            score += 2
        if file_lower.endswith(".cs"):
            score += 1
    for prefix in FRAME_PENALTY_PREFIXES:
        if method.startswith(prefix):
            score -= 3
            break
    return score


def _suspected_primary_frame(frames: List[Dict[str, Optional[str]]]) -> Optional[Dict[str, Optional[str]]]:
    if not frames:
        return None
    return max(frames, key=_score_frame)


def main() -> int:
    try:
        raw_input = _read_input()
    except Exception as exc:
        sys.stderr.write(f"Error: {exc}\n")
        return 2

    stack_strings: List[str] = []
    exceptions: List[Dict[str, Optional[str]]] = []
    stripped = raw_input.strip()
    if stripped.startswith("{"):
        try:
            payload = json.loads(stripped)
            stack_strings = _collect_stack_strings(payload)
            for item in _collect_exception_objects(payload):
                entry = _normalize_exception_entry(item)
                if entry:
                    exceptions.append(entry)
        except json.JSONDecodeError:
            stack_strings = []

    if not stack_strings:
        stack_strings = [raw_input]

    frames: List[Dict[str, Optional[str]]] = []
    for stack_text in stack_strings:
        frames.extend(_parse_frames(stack_text))

    frames = _dedupe_frames(frames)
    primary = _primary_frame(frames)
    suspected_primary = _suspected_primary_frame(frames)

    output = {
        "primary": primary,
        "suspected_primary": suspected_primary,
        "frames": frames,
        "exceptions": exceptions,
        "stack_sources": len(stack_strings),
    }
    json.dump(output, sys.stdout, indent=2, ensure_ascii=True)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
