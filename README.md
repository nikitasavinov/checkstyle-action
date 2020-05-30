# Checkstyle GitHub Action

Runs [checkstyle](https://github.com/checkstyle/checkstyle) with [reviewdog](https://github.com/reviewdog/reviewdog) on pull requests.

Example:
https://github.com/nikitasavinov/checkstyle-action/pull/2/files

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

### `tool_name`
    
Optional. Tool name to use for reviewdog reporter.
Default is 'reviewdog'.

### `workdir`
Optional. Working directory relative to the root directory.


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
```
