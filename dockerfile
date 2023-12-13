FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

RUN apt-get update && \
    apt-get install -y nodejs && \
    apt-get install -y npm

WORKDIR /src
COPY ["react.project.WebApp/react.project.WebApp.csproj", "react.project.WebApp/"]
RUN dotnet restore "react.project.WebApp/react.project.WebApp.csproj"
COPY . .
WORKDIR "/src/react.project.WebApp"
RUN dotnet build "react.project.WebApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "react.project.WebApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "react.project.WebApp.dll"]
