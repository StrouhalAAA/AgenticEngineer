---
description: Find where an API endpoint is implemented
argument-hint: <endpoint-path>
allowed-tools: Read, Glob, Grep
---

# Find Endpoint: $ARGUMENTS

## Context

Read @agentic-coding/acbs-reference/ACBS_PROJECT_REFERENCE.yaml to understand:
- Backend services list (`services`)
- API conventions (`api_conventions`)
- Search patterns (`agent_design.search_patterns.find_api_endpoint`)

## Instructions

### Step 1: Parse Endpoint Path

Extract the endpoint path from `$ARGUMENTS`.

**Expected formats**:
- Full path: `/api/v1/interest/appointments`
- Partial path: `interest/appointments`
- Method + path: `GET /api/v1/interest/appointments`

If a method is specified (GET, POST, PUT, DELETE, PATCH), note it for filtering.

### Step 2: Normalize the Path

1. Remove leading `/api/v1/` or `/api/` prefix if present
2. Extract the key segments (e.g., `interest/appointments`)
3. Identify the likely service from the first segment:
   - `interest` → InterestService
   - `lead` → LeadService
   - `vehicle` → VehicleService
   - etc.

### Step 3: Search Strategy

Search in order of likelihood:

#### Primary Search: Route Attributes

```bash
# Search for route definitions
grep -r "Route.*{endpoint}" Backend/
grep -r "\[Route.*{endpoint}" Backend/
```

#### Secondary Search: HTTP Method Attributes

```bash
# Search for HTTP method attributes with the path
grep -r "Http(Get|Post|Put|Delete).*{endpoint}" Backend/
```

#### Tertiary Search: Controller Names

If endpoint contains a noun (e.g., "appointments"):
```bash
# Search for controller with that name
find Backend/ -name "*Appointment*Controller.cs"
```

### Step 4: Analyze Results

For each match found:

1. **Identify the file**:
   - Full path: `Backend/{Service}/{Service}/Controllers/{Name}Controller.cs`
   - Service name
   - Controller name

2. **Extract the method**:
   - Method name
   - HTTP verb (Get, Post, etc.)
   - Route template
   - Parameters

3. **Find the implementation**:
   - Check if controller method calls a service
   - Identify the service method

4. **Trace the chain**:
   - Controller → Service → Repository → Database (if applicable)

### Step 5: Check Swagger Documentation

Construct Swagger URL for verification:
```
https://{service-lowercase}.api.dev.aures.app/swagger/v1/swagger.json
```

## Output Format

### Endpoint Search: `{endpoint}`

---

#### Match Found

| Property | Value |
|----------|-------|
| **Service** | {ServiceName} |
| **Controller** | {ControllerName} |
| **File** | `{full path}` |
| **Line** | {line number} |
| **HTTP Method** | {GET/POST/PUT/DELETE} |
| **Full Route** | `{complete route template}` |

---

#### Implementation Details

**Controller Method**:
```csharp
{method signature with attributes}
```

**Calls Service**:
- Service: `{ServiceName}`
- Method: `{method name}`
- File: `{service file path}`

**Database Access** (if applicable):
- Repository: `{RepositoryName}`
- Likely tables: `{table names}`

---

#### Related Endpoints

Other endpoints in the same controller:

| Method | Route | Description |
|--------|-------|-------------|
| {verb} | {route} | {brief description} |

---

#### Swagger Reference

- **Dev**: `https://{service}.api.dev.aures.app/swagger`
- **Test**: `https://{service}.api.test.aures.app/swagger`

---

### No Match Found

If no endpoint is found:

1. **Suggestions**:
   - Similar endpoints that exist
   - Correct service to check
   - Possible typos in the path

2. **Search Commands** to try manually:
   ```bash
   grep -r "{partial path}" Backend/
   ```

---

## Example Usage

```bash
# Find appointment endpoints
/find-endpoint /api/v1/interest/appointments

# Find with HTTP method
/find-endpoint GET interest/callbacks

# Find partial path
/find-endpoint vehicle/stock
```

---

## Notes

- Endpoints may be split across multiple controllers
- Some endpoints use dynamic routing with parameters like `{id}`
- Check for versioning (v1, v2) in routes
