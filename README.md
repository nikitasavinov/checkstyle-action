# Checkstyle GitHub Action

Runs [checkstyle](https://github.com/checkstyle/checkstyle) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests.

Example:

[![github-pr-check sample](https://user-images.githubusercontent.com/6826684/107879090-1a1c0500-6ed7-11eb-9260-14acdc94ad36.png)](https://github.com/nikitasavinov/checkstyle-action/pull/2/files)

Or look here: https://github.com/nikitasavinov/checkstyle-action/pull/48

## Release notes

### 1.0.0 upgrade

Version 1.0.0 changes the default Checkstyle version from `10.3` to `13.9.0`.
Checkstyle 13 includes breaking configuration changes; notably, `JavadocStyle`
was removed in 13.9.0 in favor of `SummaryJavadoc`. Update custom configurations
accordingly, or set `checkstyle_version: '10.3'` while migrating.

The `fail_on_error` input is deprecated, and its behavior changes with the
reviewdog upgrade. Under the default `github-pr-check` reporter,
`fail_on_error: true` now fails only on error-severity findings; version 0.6.0
failed on warnings as well. To preserve the old any-severity behavior, set
`fail_level: any`. New workflows should use `fail_level` directly.

## Input

### `checkstyle_config`

[Checkstyle config](https://checkstyle.sourceforge.io/config.html).
Defaults to `google_checks.xml` (`sun_checks.xml` is also built in and available).

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Optional. Reporter of reviewdog command [github-pr-check,github-pr-review].
It's same as `-reporter` flag of reviewdog.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is `added`.

### `fail_level`

Optional. Exit code for reviewdog when findings are at or above this level
[none,any,info,warning,error].
This is compared against each finding's severity from Checkstyle XML, not the
`level` input.
By default this is unset, allowing reviewdog to apply its reporter-specific
`fail_on_error` compatibility behavior. When set, `fail_level` takes precedence.

### `fail_on_error`

Deprecated. Prefer `fail_level`.

Optional. Exit code for reviewdog when errors are found [true,false].
Default is `false`. It is only consulted when `fail_level` is unset. With
reviewdog 0.21, `true` fails on error-severity findings for `github-check` and
`github-pr-check`, and on any finding for other reporters. Use
`fail_level: any` for consistent any-severity failure behavior.

### `tool_name`
    
Optional. Tool name to use for reviewdog reporter.
Default is 'reviewdog'.

### `workdir`
Optional. Working directory relative to the root directory.

### `checkstyle_version`
Optional. Checkstyle version to use.
Default is `13.9.0`

### `properties_file`
Optional. Properties file relative to the root directory.

## Example usage

```yml
on: pull_request

jobs:
  checkstyle_job:
    runs-on: ubuntu-latest
    name: Checkstyle job
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    - name: Run check style
      uses: nikitasavinov/checkstyle-action@1.0.0
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        reporter: 'github-pr-check'
        tool_name: 'testtool'
```
