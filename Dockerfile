FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 10000
ENV ASPNETCORE_URLS=http://+:10000

FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

COPY ["TicketSystemVentura.API/TicketSystemVentura.API.csproj", "TicketSystemVentura.API/"]
COPY ["TicketSystem.Application/TicketSystem.Application.csproj", "TicketSystem.Application/"]
COPY ["TicketSystem.Domain/TicketSystem.Domain.csproj", "TicketSystem.Domain/"]
COPY ["TicketSystem.Infrastructure/TicketSystem.Infrastructure.csproj", "TicketSystem.Infrastructure/"]

RUN dotnet restore "TicketSystemVentura.API/TicketSystemVentura.API.csproj"

COPY . .

WORKDIR "/src/TicketSystemVentura.API"
RUN dotnet build "TicketSystemVentura.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TicketSystemVentura.API.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TicketSystemVentura.API.dll"]