# Use the official ASP.NET Core runtime as the base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use the official .NET SDK as the build image
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["SampleMvcApp.csproj", "./"]
RUN dotnet restore "SampleMvcApp.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "SampleMvcApp.csproj" -c Release -o /app/build

# Publish the app
FROM build AS publish
RUN dotnet publish "SampleMvcApp.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleMvcApp.dll"]
