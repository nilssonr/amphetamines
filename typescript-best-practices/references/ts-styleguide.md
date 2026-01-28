# Google TypeScript Style Guide (Condensed)

## Table of contents
- Source files
- File structure and modules
- Imports and exports
- Variables
- Arrays
- Objects
- Functions and this
- Control flow and errors
- Literals and coercion
- Classes
- Decorators
- Type system
- Assertions
- Naming
- Comments and documentation
- Toolchain
- Disallowed features and formatting
- Policies

## Source files
- Encode files as UTF-8.
- Use ASCII space (0x20) as the only whitespace character outside of line terminators.
- Escape non-ASCII whitespace in string literals.
- Use named escape sequences for special characters; never use legacy octal escapes.
- Use actual Unicode characters for printable non-ASCII when it improves readability; use escape sequences for non-printable characters and explain with a comment.

## File structure and modules
- Order file content as: optional copyright JSDoc, optional @fileoverview JSDoc, imports, implementation.
- Separate each section with a single blank line.
- Put copyright in a top-of-file JSDoc block if required.
- Use @fileoverview only when useful; do not indent its content.
- Use ES module syntax (import/export); avoid namespaces and require().
- Avoid container classes used only for namespacing; export standalone functions, constants, or interfaces instead.

## Imports and exports
- Prefer named exports; avoid default exports.
- Minimize exported API surface; do not export mutable values directly.
- Prefer getter functions over exporting mutable data (`export let` is disallowed).
- Use `import type` and `export type` for type-only imports or re-exports.
- Use side-effect imports only for side effects.
- Choose named imports when a small set of symbols is used; prefer namespace imports when many members are used or to avoid awkward renames.
- Use rename imports only when necessary to resolve conflicts or improve clarity.

## Variables
- Use `const` by default; use `let` only for reassignment; never use `var`.
- Declare one variable per declaration.
- Do not use variables before they are declared.

## Arrays
- Avoid the `Array` constructor except for `Array.from` or when intentionally creating a sparse array.
- Do not add non-numeric properties to arrays.
- Spread only iterables into array literals; do not spread possibly null or undefined values.
- Use array destructuring when it improves readability; avoid unused bindings.
- When destructuring optional array parameters, default to `[]` and provide per-item defaults on the left-hand side.

## Objects
- Avoid the `Object` constructor; use object literals.
- Use `for...in` only for dictionary-like objects and always guard with `hasOwnProperty`.
- Prefer `Object.keys/values/entries` with `for...of` for iterating object data.
- Spread only plain objects; avoid spreading class instances, arrays, or primitives.
- Treat computed property names as quoted keys unless they are symbols.
- Keep parameter object destructuring simple (one level, no computed keys); use defaults on the left-hand side.
- For optional destructured objects, default the parameter to `{}`.

## Functions and this
- Prefer function declarations for named functions.
- Use arrow functions for callbacks and nested functions that capture `this`.
- Avoid function expressions unless required for generator functions or dynamic `this`.
- Use concise arrow bodies only when returning a value; otherwise use block bodies.
- Avoid passing named callbacks when signatures are unclear; prefer arrows that forward arguments.
- Do not use arrow function properties on classes by default; allow for event handlers that must be removed later.
- Avoid `bind` inside listener installation; use stable handler references.
- Keep default parameter expressions simple and side-effect free.
- Prefer rest parameters over `arguments`; do not name any variable `arguments`.
- Prefer spread over `apply`.
- Use `this` only in class constructors, class methods, functions with explicit `this` parameter types, or arrows that close over a known `this`.

## Control flow and errors
- Always use braces for control flow blocks; the only exception is a single-line `if` on one line.
- Avoid assignments in conditionals; if unavoidable, wrap the assignment in extra parentheses.
- Use `for...of` for arrays; reserve `for...in` for dictionary objects with `hasOwnProperty` checks.
- Use grouping parentheses only to clarify precedence.
- Throw `Error` (or subclasses), not strings or arbitrary values.
- Create errors with `new Error` and include clear messages.
- Assume caught errors are `Error`; validate or document exceptions from known-bad APIs.
- Do not leave empty catch blocks without a comment explaining why.
- Put `default` last in `switch` statements.
- Do not allow fallthrough in non-empty `switch` cases.
- Use `===` and `!==`; do not use `==` or `!=`.

## Literals and coercion
- Use single quotes for string literals; do not use line continuations.
- Use template literals for complex concatenation or multiline strings.
- Use lowercase numeric prefixes: `0x`, `0o`, `0b`.
- Never use a leading zero to imply octal.
- Use `String(...)`, `Boolean(...)`, template literals, or `!!` for explicit coercion (never with `new`).
- Do not explicitly or implicitly coerce enum values to boolean; compare explicitly.
- Avoid explicit boolean coercion in conditionals; rely on implicit truthiness for non-enum values.
- Prefer `Number(...)` plus `Number.isNaN` or `Number.isFinite` for parsing numbers.
- Avoid unary `+` for numeric coercion.
- Avoid `parseInt` and `parseFloat` for base-10 parsing; if you must use `parseInt` for non-base-10, validate the input and always pass a radix.

## Classes
- Do not end class declarations with semicolons; do end class expressions assigned to `const` with a semicolon.
- Do not use semicolons after method declarations.
- Separate class methods with a single blank line.
- Override `toString` only if it is side-effect free and cannot throw.
- Prefer module-level functions over private static methods when possible.
- Avoid dynamic dispatch of static methods; do not call statics via subclasses unless defined there.
- Do not use `this` inside static methods.
- Use parentheses in constructor calls even when there are no arguments.
- Omit unnecessary constructors (e.g., ones that only call `super`).
- Include a constructor when using parameter properties, visibility modifiers, or decorators.
- Put a blank line around the constructor.
- Limit visibility as much as possible; avoid `public` except for non-readonly public parameter properties.
- Do not use `#private` fields; use TypeScript access modifiers.
- Mark properties `readonly` when they are not reassigned after construction.
- Prefer parameter properties for straightforward assignments; document them with `@param` in the constructor JSDoc.
- Initialize properties at declaration; do not add or remove properties after construction.
- Do not access private members with bracket notation (e.g., `obj['private']`).
- Keep getters pure; avoid trivial getters/setters that add no value.
- Avoid `Object.defineProperty`; use standard class fields.
- Use computed property names in classes only for symbol keys.

## Decorators
- Do not define new decorators; use framework-provided decorators only.
- Place decorators immediately before the decorated symbol with no blank line.
- Put JSDoc before decorators.

## Type system
- Rely on type inference for trivial initializations; add explicit types when they improve clarity or avoid undesired inference.
- Add return type annotations when required for clarity or API stability.
- Prefer optional properties/parameters over `| undefined`.
- Avoid nullable type aliases; add `null` or `undefined` at the usage site instead.
- Prefer interfaces over type aliases for object shapes; use type aliases for unions, tuples, or mapped/conditional types.
- Prefer `T[]` or `readonly T[]` for simple array types; use `Array<T>` or `ReadonlyArray<T>` for complex types.
- Prefer `Map`/`Set` to index signatures; when using index signatures, use meaningful key names; use `Record` for fixed key maps.
- Use mapped and conditional types sparingly; keep type complexity low.
- Avoid `any`; prefer specific types or `unknown` with narrowing.
- Do not use `{}` to mean "any value"; use `unknown` or `Record<string, unknown>` or `object` depending on intent.
- Prefer tuples for fixed-length positional data; prefer named object types for clarity.
- Do not use wrapper types (`String`, `Boolean`, `Number`, `Object`).
- Avoid generics used only in return types; explicitly supply generics where required by APIs.

## Assertions
- Avoid type assertions and non-null assertions; prefer runtime checks.
- Use `as` syntax, not angle-bracket assertions.
- For unsafe conversions, use double assertion through `unknown`.
- Prefer type annotations over assertions for object literals.

## Naming
- Use only ASCII letters, digits, underscores (for constants and structured test names), and rarely `$` when required by a framework.
- Use clear, descriptive names; avoid obscure abbreviations or abbreviations formed by deleting letters.
- Treat acronyms as words (e.g., `loadHttpUrl`, not `loadHTTPURL`).
- Avoid `$` in identifiers unless required by a framework or a well-established convention (e.g., Observables), and be consistent.
- Use UpperCamelCase for classes, interfaces, types, enums, decorators, and type parameters.
- Use lowerCamelCase for variables, functions, methods, properties, and module aliases.
- Use CONSTANT_CASE for global constants and enum values.
- Allow single-letter or abbreviated type parameters only when conventional (e.g., `T`, `U`).
- Allow short names only for very small scopes (about 10 lines or less) or non-exported parameters.
- Do not use leading or trailing underscores and do not use `_` as a standalone identifier.
- Do not use the `opt_` prefix for optional parameters.
- Do not prefix interfaces (e.g., `IMyInterface`); choose descriptive names instead.
- Keep alias casing consistent with the original identifier.

## Comments and documentation
- Use JSDoc for API and public documentation; use `//` for implementation comments.
- Use `//` for multi-line comments; do not use `/* */` for multi-line or boxed comments.
- Format JSDoc with `/** ... */` and Markdown lists when helpful.
- Keep `@fileoverview` content unindented.
- Put each JSDoc tag on its own line; wrap descriptions with a four-space indent.
- Document top-level exports and any non-obvious class members.
- Start method and function docs with a third-person verb phrase.
- Document parameter properties with `@param` in constructor JSDoc.
- Do not use JSDoc type annotations in TypeScript (`@param {type}`, `@return {type}`, `@implements`, `@override`, `@private`).
- Ensure comments add information beyond the code itself.
- Use parameter name comments at call sites only when needed; prefer refactoring to object parameters.
- Place JSDoc before decorators.

## Toolchain
- Require TypeScript compiler type checking.
- Use `@ts-expect-error` sparingly and prefer it in tests; document why.
- Follow local conformance rules (e.g., tsetse/tsec) when present.

## Disallowed features and formatting
- Do not rely on Automatic Semicolon Insertion; end statements with semicolons.
- Do not use `const enum`; use `enum` instead.
- Do not include `debugger` statements in production code.
- Do not use `with`.
- Do not use `eval` or `Function(...string)` except for code loaders.
- Do not use non-standard or deprecated platform features.
- Do not modify builtin prototypes or constructors; avoid libraries that do.
- Do not add symbols to the global object unless required by a third-party API.
- Do not manipulate prototypes directly in application code; avoid mixins unless a framework requires it.

## Policies
- Follow existing file and directory style when unspecified.
- Apply Google style to new files.
- Avoid mixing unrelated style changes with functional changes.
- Reformat when making significant changes that benefit readability.
- Mark deprecated APIs with `@deprecated` and include migration guidance.
- Generated code is mostly exempt; apply naming rules to exported identifiers and any human-authored edits.
