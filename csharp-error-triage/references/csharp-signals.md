# C# Repo Signals

Use these signals to confirm the repository is C#/.NET:

- `*.csproj` (project files)
- `*.sln` (solution files)
- `Directory.Build.props` or `Directory.Build.targets`
- `global.json` (often used for .NET SDK pinning)
- `*.cs` (C# source files)

Suggested checks:

- `rg --files -g '*.csproj' -g '*.sln' -g 'Directory.Build.*' -g 'global.json' -g '*.cs'`
- If the repo is large, prefer `.csproj`/`.sln`/`Directory.Build.*` over raw `*.cs`.
