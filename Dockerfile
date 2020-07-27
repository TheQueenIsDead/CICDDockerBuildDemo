# Set up default build arguments, can be overriden by CICD
ARG BUILD_IMAGE=mcr.microsoft.com/dotnet/core/sdk:3.1
ARG RUNTIME_IMAGE=mcr.microsoft.com/dotnet/core/aspnet:3.1
ARG RESTORE_COMMAND='dotnet restore'
ARG PUBLISH_COMMAND='dotnet publish -c Release -o out'

# Build the project
FROM "${BUILD_IMAGE}" AS build
# Denotes we use the following args for this stage:
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG RESTORE_COMMAND
ARG PUBLISH_COMMAND

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./CICDDockerBuildDemo.sln ./CICDDockerBuildDemo.sln
COPY ./CICDDockerBuildDemo/CICDDockerBuildDemo.csproj ./CICDDockerBuildDemo/CICDDockerBuildDemo.csproj
COPY ./CICDDockerBuildDemo.Tests.Unit/CICDDockerBuildDemo.Tests.Unit.csproj ./CICDDockerBuildDemo.Tests.Unit/CICDDockerBuildDemo.Tests.Unit.csproj
RUN echo "Doing: $RESTORE_COMMAND" && ${RESTORE_COMMAND}

# Copy everything else and build
COPY . ./
RUN echo "Doing: ${PUBLISH_COMMAND}" && ${PUBLISH_COMMAND}

# Build runtime image
FROM "${RUNTIME_IMAGE}" as publish
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "CICDDockerBuildDemo.dll"]