#!/bin/bash
set -e
mkdir output
node generate.js hosts.yml $(git show -s --format=%cd --date=short) output
if [ "$PUSH_TO_MASTER" == "true" ]; then
	echo $DEPLOY_KEY | base64 -d > ~/.ssh/id_ed25519
	chmod 600 ~/.ssh/id_ed25519
	git clone git@github.com:$TRAVIS_REPO_SLUG master
	cp output/* master/
	cd master
	if [ -n "$(git status --porcelain)" ]; then
		git add -A
		git config --global user.name $(git show -s --format="%aN" $TRAVIS_COMMIT)
		git config --global user.email $(git show -s --format="%aE" $TRAVIS_COMMIT)
		git config --global push.default simple
		{ printf "Update hosts from hosts-source.\n\n" & git log --format="%H %s" $TRAVIS_COMMIT_RANGE; } | GIT_COMMITTER_DATE=$(git show -s --format="%cD" $TRAVIS_COMMIT) git commit -F -
		git push
	fi
fi
