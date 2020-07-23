FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./CICDDockerBuildDemo.sln ./CICDDockerBuildDemo.sln
COPY ./CICDDockerBuildDemo/CICDDockerBuildDemo.csproj ./CICDDockerBuildDemo/CICDDockerBuildDemo.csproj
COPY ./CICDDockerBuildDemo.Tests.Unit/CICDDockerBuildDemo.Tests.Unit.csproj ./CICDDockerBuildDemo.Tests.Unit/CICDDockerBuildDemo.Tests.Unit.csproj
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as publish
WORKDIR /app
COPY --from=build /app/out .
ENTRYPOINT ["dotnet", "CICDDockerBuildDemo.dll"]