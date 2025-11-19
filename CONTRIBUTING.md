## Contributing

[code-of-conduct]: CODE_OF_CONDUCT.md

Hi there! We're thrilled that you'd like to contribute to this project. Your help is essential for keeping it great.

Please note that this project is released with a [Contributor Code of Conduct][code-of-conduct]. By participating in this project you agree to abide by its terms.

## Prerequisites for running and testing code locally

There are one time installations required to be able to test your changes locally as part of the pull request (PR) submission process.

Please look at the README.md file for instructions on setting up the development environment, installing dependencies, and running tests.

## Submitting a pull request

1. Raise an issue to discuss the change required.
2. Make the changes in a new branch in the the repository.
3. Raise a pull request (PR) against the `master` branch of this repository. Be sure to include a clear description of the changes you have made and link to the issue you raised in step 1.
4. Pat your self on the back and wait for your pull request to be reviewed and merged.

- Keep your change as focused as possible. If there are multiple changes you would like to make that are not dependent upon each other, consider submitting them as separate pull requests.
- Write a [good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html). We prefer [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style commit messages.

### Release PRs

To prepare a release, use the GitHub Actions workflow `2. Create Release PR [Manual]` from the `master` branch. It will:
- Bump the version using Commitizen and update the changelog
- Create a branch named `release/v<version>`
- Open a PR targeting `master` for review and merge

After merging the release PR, follow your organization’s publish/tag process or a dedicated publish workflow if configured.

## Resources

- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
