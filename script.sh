yarn config set version-git-tag false
npm install project-version

git fetch --all --tags

CURRENT_COMMIT_HASH=$(git rev-parse HEAD)
LATEST_TAG_HASH=$(git rev-list -1 --tags)
LATEST_TAG_NAME=$(git tag -l | sort -V | tail -1)

if [ "$CURRENT_COMMIT_HASH" = "$LATEST_TAG_HASH" ]; then
    echo "There's already a tag assigned to HEAD commit. Setting version to $LATEST_TAG_NAME" # use this as version
    npm version --no-git-tag-version $LATEST_TAG_NAME 2>/dev/null || :
else
    echo "Getting latest tag: $LATEST_TAG_NAME"
    echo "Incrementing minor"
    npm version --no-git-tag-version $LATEST_TAG_NAME 2>/dev/null || :
    yarn version --patch
    VERSION=$(npx project-version)
    git tag -a $VERSION -m "Automatic tagging by pipeline. To set a custom version please tag the last <main> commit before running the pipeline." 
    git push origin $VERSION
fi
