# git scripts

## Installation

```sh
$ git clone https://github.com/markhemstead/git-scripts
$ cd git-scripts && chmod +x git-*
```

And in your .basrc, .zsgrc or .bash_profile file add the new path to $PATH
```sh
export PATH="$PATH:/full/path/to/git-scripts"
```

## Usage

### git-cleanup
Deletes all local branches that no longer have an attached remote, i.e. merged branches. Excludes `master`, `develop` and `main` branches

Example:
```sh
$ git cleanup
Deleting branch hotfix/my-import-hotfix
Deleting branch hotfix/my-import-hotfix-final
```

### git new
Creates a new branch with the given name, or if the branch exists, switches to it. The remote is also checked if it's not a branch you've used before (to ensure no conflicting names).

There's a [y/n] prompt in case you make a mistake in the name and you can abort.

Example:
```sh
$ git new my-new-feature
Branch my-new-feature does not exist. Do you want to create it? [y/n] y
Creating branch my-new-feature
```

### git pr
Opens browser to the GitHub Pull Request page for your branch to develop. Add an argument for the branch to merge to

Example:
```sh
$ git pr # Opens browser to the GitHub PR page for your current branch to merge develop
$ git pr master # Opens browser to the GitHub PR page for your current branch to merge to master
```

### git refresh
Updates your local master, develop, and current selected branch without changing branches

Example:
```sh
$ git refresh
Updating master... done
Updating develop... done
Updating feature/my-new-feature... done
```
