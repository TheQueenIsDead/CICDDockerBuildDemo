
echo "Starting build"
DOCKER_IMAGE=demo-build-example
# build
docker build . -t "$DOCKER_IMAGE:build" --target build
# test
docker run --rm -v "$PWD/build_results:/results" "$DOCKER_IMAGE:build" dotnet test --collect:"XPlat Code Coverage" --logger:trx --results-directory:/results
# publish
echo "Going to publish now...Up up and away"