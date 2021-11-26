git fetch --all --tags
yarn config set version-git-tag false

CURRENT_COMMIT_HASH=$(git rev-parse HEAD)
LATEST_TAG_HASH=$(git rev-list -1 --tags)
LATEST_TAG_NAME=$(git tag | head -1)

if [ "$CURRENT_COMMIT_HASH" = "$LATEST_TAG_HASH" ]; then
    echo "There's already a tag assigned to HEAD commit. Setting version to $LATEST_TAG_NAME" # use this as version
    npm version --no-git-tag-version $LATEST_TAG_NAME
else
    echo "Getting latest tag: $LATEST_TAG_NAME"
    echo "Incrementing minor"
    npm version --no-git-tag-version $LATEST_TAG_NAME
    yarn version --patch
    npm version
fi
 



#npm version --no-git-tag-version 0.35.24
#git tag -a 0.25.24 -m "Automatic tagging by pipeline. To set a custom version please tag the last <main> commit before running the pipeline." 
#git push origin 0.25.24



#git fetch --all --tags
#git tag