# ACBS Project Context

> Example CLAUDE.md demonstrating how to inject the project reference into Claude's context.

## Purpose

This file shows how a real project would reference the ACBS YAML to give Claude structural awareness.

## Project Structure

This is the **ACBS (Aures Core Business Systems)** monorepo for automotive CRM and sales management.

**Architecture reference:** @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml

## Quick Context

- **10 business domains**: customer, vehicle, sales, financial, document, communication, auth, settings, reporting, integration
- **10 frontend products**: CRM (Vue 3), FNI (Vue 2), phones, kiosek, etc.
- **56 backend services**: .NET 8 microservices
- **16 database schemas**: SQL Server with FX2 procedures

## Commands

Available parameterized commands:

| Command | Description |
|---------|-------------|
| `/audit <domain>` | Audit all components in a business domain |
| `/analyze <product> <layer>` | Analyze specific product layer |
| `/find-endpoint <path>` | Find API endpoint implementation |
| `/build <product>` | Build a frontend product |
| `/test <service>` | Run tests for a backend service |

## Domain Quick Reference

When working with domains, use these keywords to identify context:

- **customer**: lead, person, company, contact, client
- **vehicle**: car, stock, inventory, pricing, AVB
- **sales**: interest, deal, appointment, callback, cart
- **financial**: commission, claim, FNI, invoice
- **document**: photo, scan, OCR, 360, attachment

## Development Patterns

### Frontend (Vue 3/TypeScript)
```bash
cd Frontend/{product} && npm run dev
```

### Backend (.NET 8)
```bash
dotnet run --project Backend/{ServiceName}/{ServiceName}/{ServiceName}.csproj
```

### Resolution Example

When given `domain: sales`:
- Backend services: InterestService, DealService, CalendarService
- Frontend products: CRM, kiosek
- Database schemas: interest, Deal

## Important

Always read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml before:
- Resolving domain/product/service names
- Constructing file paths
- Looking up service integrations
- Building API URLs
