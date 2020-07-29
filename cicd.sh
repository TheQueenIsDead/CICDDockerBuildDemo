RUN_SONARQUBE=0


echo "Starting build"

DOCKER_IMAGE=demo-build-example
# build
docker build . -t "$DOCKER_IMAGE:build" --target build
# test
echo "Running $TEST_COMMAND";
docker run --rm -v "$PWD/build_results:/results" "$DOCKER_IMAGE:build" dotnet test --collect:"XPlat Code Coverage" --logger:trx --results-directory:/results
# analyse
docker run \
    --rm \
    --network=host \
    -e SONAR_HOST_URL="http://localhost:9000" \
    -v "$PWD:/usr/src" \
    sonarsource/sonar-scanner-cli -Dsonar.projectKey=myproject

# publish
echo "Going to publish now...Up up and away"
