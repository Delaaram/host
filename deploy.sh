#!/bin/bash
set -e
mkdir output
node generate.js hosts.yml $(git show -s --format=%cd --date=short) output
if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
	openssl aes-256-cbc -K $encrypted_d73e5dbd4f94_key -iv $encrypted_d73e5dbd4f94_iv -in deploy-key.enc -out ~/.ssh/id_rsa -d
	chmod 600 ~/.ssh/id_rsa
	git clone git@github.com:$TRAVIS_REPO_SLUG master
	cp output/* master/
	cd master
	git add -A
	git config --global user.name $(git show -s --format="%aN" $TRAVIS_COMMIT)
	git config --global user.email $(git show -s --format="%aE" $TRAVIS_COMMIT)
	git config --global push.default simple
	git show -s --format="%B" $TRAVIS_COMMIT | GIT_COMMITTER_DATE=$(git show -s --format="%cD" $TRAVIS_COMMIT) git commit -F -
	git push
fi
