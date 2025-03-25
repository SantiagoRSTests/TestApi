# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
# Copia el archivo de proyecto y restaura las dependencias
COPY ["TestApi/TestApi.csproj", "TestApi/"]
RUN dotnet restore "TestApi/TestApi.csproj"
# Copia el resto de la solución
COPY . .
WORKDIR /src/TestApi
# Publica la aplicación en modo Release
RUN dotnet publish "TestApi.csproj" -c Release -o /app/publish

# Etapa de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80

ENV ASPNETCORE_URLS=http://+:80
ENTRYPOINT ["dotnet", "TestApi.dll"]
