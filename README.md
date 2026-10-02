# Repro: `dn pub get` in a Dart-only package writes app files into it

A Dart-only package (no native code, no `dartnative:` block) that depends on
`dartnative_path_provider`. Running `dn pub get` in it treats the package as
an app: it writes `lib/dartnative_plugin_registrant.dart`, `dn_plugins.lock`
and `.dn-plugins-dependencies`, and layers compiled plugin modules "for this
app".

## Run

```sh
./repro.sh        # runs `dn pub get`, then `git status`
```

## What you'll see

```console
Resolving dependencies...
Downloading packages...
+ ffi 2.2.0
+ meta 1.19.0
Changed 2 dependencies!
dartnative: plugin version for this app: dartnative_path_provider 1.0.0 (recorded in dn_plugins.lock).
dartnative: layered 1 compiled plugin module(s) onto the debug platform for this app.
dartnative: layered 1 compiled plugin module(s) onto the product platform for this app.

--- files dn pub get added to the package (git status):
?? .dn-plugins-dependencies
?? dn_plugins.lock
?? lib/dartnative_plugin_registrant.dart
```

## Expected

In a package, `dn pub get` resolves dependencies only. The registrant, the
plugin lock and the layered modules belong to the app that uses the package.

## Why it matters

- `lib/dartnative_plugin_registrant.dart` lands in the package's `lib/`, so
  it is part of the published package unless every author remembers to
  ignore it.
- Each package repo needs `.gitignore` entries for three generated files.

## Environment

- DartNative 1.0.0 (SDK `113c27aacb2`, framework edition `7ae29132`), Dart 3.12.0
- macOS 26.7.1
