FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["TestHelloWorld/TestHelloWorld.csproj", "TestHelloWorld/"]
RUN dotnet restore "TestHelloWorld/TestHelloWorld.csproj"
COPY . .
WORKDIR "/src/TestHelloWorld"
RUN dotnet build "TestHelloWorld.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "TestHelloWorld.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "TestHelloWorld.dll"]