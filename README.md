# Checkstyle GitHub Action

Runs [checkstyle](https://github.com/checkstyle/checkstyle) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests.

Example:

[![github-pr-check sample](https://user-images.githubusercontent.com/6826684/107879090-1a1c0500-6ed7-11eb-9260-14acdc94ad36.png)](https://github.com/nikitasavinov/checkstyle-action/pull/2/files)


## Input

### `checkstyle_config`

Required. [Checkstyle config](https://checkstyle.sourceforge.io/config.html)
Default is `google_checks.xml` (`sun_checks.xml` is also built in and available).

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Optional. Reporter of reviewdog command [github-pr-check,github-pr-review].
It's same as `-reporter` flag of reviewdog.

### `filter_mode`

Optional. Filtering mode for the reviewdog command [added,diff_context,file,nofilter].
Default is `added`.

### `fail_on_error`

Optional.  Exit code for reviewdog when errors are found [true,false].
Default is `false`.

**Important**: this feature only works when `level` is set to `error`.

### `tool_name`
    
Optional. Tool name to use for reviewdog reporter.
Default is 'reviewdog'.

### `workdir`
Optional. Working directory relative to the root directory.

### `checkstyle_version`
Optional. Checkstyle version to use.
Default is `8.40`

### `properties_file`
Optional. Properties file relative to the root directory.

## Example usage

``` yml
on: pull_request

jobs:
  checkstyle_job:
    runs-on: ubuntu-latest
    name: Checkstyle job
    steps:
    - name: Checkout
      uses: actions/checkout@v2
    - name: Run check style
      uses: nikitasavinov/checkstyle-action@master
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
        reporter: 'github-pr-check'
        tool_name: 'testtool'
```
