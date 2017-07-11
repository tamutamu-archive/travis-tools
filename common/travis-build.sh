export REPO_USER=nablarch

export DEVELOP_REPO_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com
export DEVELOP_REPO_NAME=repo


#/--- ****今だけ***** 
#  gradleプラグインのインストール
git clone -b feature-travis https://github.com/travis-nab/nablarch-gradle-plugin.git
pushd nablarch-gradle-plugin
chmod +x gradlew
./gradlew install
popd
#****今だけ***** ---/


# if it creates pull request, execute `gradlew build` only.
# if it merges pull request to develop branch or dilectly commit on develop branch, execute `gradlew uploadArchives`.
# Waning, TRAVIS_PULL_REQUEST variable is 'false' or pull request number, 1,2,3 and so on.

echo "@@@@@@@@@@@@@@@@@"
echo ${TRAVIS_BRANCH}
echo ${TRAVIS_PULL_REQUEST}
echo ${TRAVIS_REPO_SLUG}
echo ${TRAVIS_BUILD_DIR}
echo ${TRAVIS_PULL_REQUEST_BRANCH}
echo "@@@@@@@@@@@@@@@@@"

if [ "${TRAVIS_PULL_REQUEST}" == "false" -a "${TRAVIS_BRANCH}" == "develop"  ]; then
  ./gradlew uploadArchives -PnablarchRepoUsername=${REPO_USER} -PnablarchRepoPassword=${DEPLOY_PASSWORD} \
                           -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                           -PnablarchRepoDeployUrl=dav:${DEVELOP_REPO_URL} -PnablarchRepoName=${DEVELOP_REPO_NAME} \
                           --no-daemon
else
  ./gradlew build -PnablarchRepoUsername=${REPO_USER} -PnablarchRepoPassword=${DEPLOY_PASSWORD} \
                  -PnablarchRepoReferenceUrl=${DEVELOP_REPO_URL} -PnablarchRepoReferenceName=${DEVELOP_REPO_NAME} \
                  -PnablarchRepoDeployUrl=dav:${DEVELOP_REPO_URL} -PnablarchRepoName=${DEVELOP_REPO_NAME} \
                  --no-daemon
fi


# Upload Unit test report.
