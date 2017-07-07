export REPO_USER=nablarch

export DEVELOP_REPO_URL=http://ec2-52-199-35-248.ap-northeast-1.compute.amazonaws.com
export DEVELOP_REPO_NAME=repo


# ***************
# ****今だけ***** 
# ***************
#  gradleプラグインのインストール
git clone -b feature-travis https://github.com/travis-nab/nablarch-gradle-plugin.git
pushd nablarch-gradle-plugin
chmod +x gradlew
./gradlew install
popd


# if Create Pull Request, execute `gradlew build` only.
# if Merge Pull Request or directory commit, `gradlew uploadArchives`.
if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
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
