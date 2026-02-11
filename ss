{
  "openapi": "3.1.0",
  "info": {
    "title": "ClickUp Projects + Gantt (GPT)",
    "version": "1.0.3",
    "description": "ClickUp API v2 via API Key. Endpoints for Workspaces, Spaces, Task, Folder and Dependencies."
  },
  "servers": [
    {
      "url": "https://api.clickup.com",
      "description": "ClickUp API (host raiz)"
    }
  ],
  "paths": {
    "/api/v2/team": {
      "get": {
        "operationId": "getTeams",
        "summary": "Listar Workspaces (Teams)",
        "description": "Retorna os Workspaces disponíveis para o usuário autenticado.",
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/GetTeamsResponse" }
              }
            }
          }
        }
      }
    },
    "/api/v2/team/{team_id}/space": {
      "get": {
        "operationId": "getSpaces",
        "summary": "Listar Spaces de um Workspace",
        "description": "Use primeiro getTeams para obter um team_id válido.",
        "parameters": [
          { "name": "team_id", "in": "path", "required": true, "schema": { "type": "string" }, "description": "ID do Workspace (team.id) retornado em /team" },
          { "name": "archived", "in": "query", "required": false, "schema": { "type": "boolean", "default": false }, "description": "Se true, inclui spaces arquivados" }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/GetSpacesResponse" }
              }
            }
          }
        }
      }
    },
    "/api/v2/task/{task_id}": {
      "get": {
        "operationId": "getTask",
        "summary": "Obter detalhes de uma Task",
        "description": "Retorna os dados da task pelo task_id.",
        "parameters": [
          { "name": "task_id", "in": "path", "required": true, "schema": { "type": "string" }, "description": "ID da task no ClickUp" },
          { "name": "include_subtasks", "in": "query", "required": false, "schema": { "type": "boolean", "default": false }, "description": "Se true, inclui subtasks" }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Task" }
              }
            }
          }
        }
      }
    },
    "/api/v2/task/{task_id}/dependency": {
      "post": {
        "operationId": "addDependency",
        "summary": "Adicionar dependência entre tasks",
        "description": "Cria uma dependência para a task indicada em task_id. Use depends_on para informar qual task ela depende.",
        "parameters": [
          { "name": "task_id", "in": "path", "required": true, "schema": { "type": "string" }, "description": "ID da task que receberá a dependência" }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": { "$ref": "#/components/schemas/AddDependencyRequest" }
            }
          }
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/DependencyResponse" }
              }
            }
          },
          "400": {
            "description": "Bad Request",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/ErrorResponse" }
              }
            }
          }
        }
      }
    },
    "/api/v2/space/{space_id}/folder": {
      "post": {
        "operationId": "createFolder",
        "summary": "Criar Folder em um Space",
        "description": "Cria uma pasta (Folder) dentro de um Space. Primeiro obtenha space_id via getSpaces.",
        "parameters": [
          { "name": "space_id", "in": "path", "required": true, "schema": { "type": "string" }, "description": "ID do Space" }
        ],
        "requestBody": {
          "required": true,
          "content": {
            "application/json": {
              "schema": { "$ref": "#/components/schemas/CreateFolderRequest" }
            }
          }
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/Folder" }
              }
            }
          },
          "400": {
            "description": "Bad Request",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/ErrorResponse" }
              }
            }
          }
        }
      }
    }
  },
  "components": {
    "schemas": {
      "GetTeamsResponse": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "teams": { "type": "array", "items": { "$ref": "#/components/schemas/Team" } }
        }
      },
      "Team": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "id": { "type": "string" },
          "name": { "type": "string" }
        }
      },
      "GetSpacesResponse": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "spaces": { "type": "array", "items": { "$ref": "#/components/schemas/Space" } }
        }
      },
      "Space": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "id": { "type": "string" },
          "name": { "type": "string" }
        }
      },
      "Task": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "id": { "type": "string" },
          "name": { "type": "string" },
          "status": { "type": "object", "additionalProperties": true },
          "due_date": { "type": ["string", "null"] },
          "start_date": { "type": ["string", "null"] }
        }
      },
      "AddDependencyRequest": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "depends_on": { "type": "string", "description": "ID da task da qual a task_id depende" },
          "dependency_of": { "type": "string", "description": "Opcional: ID da task que depende da task_id (uso alternativo)" }
        },
        "anyOf": [ { "required": ["depends_on"] }, { "required": ["dependency_of"] } ]
      },
      "DependencyResponse": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "id": { "type": ["string", "number", "null"] }
        }
      },
      "CreateFolderRequest": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "name": { "type": "string", "description": "Nome do Folder" }
        },
        "required": ["name"]
      },
      "Folder": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "id": { "type": "string" },
          "name": { "type": "string" }
        }
      },
      "ErrorResponse": {
        "type": "object",
        "additionalProperties": true,
        "properties": {
          "err": { "type": "string" },
          "code": { "type": "string" },
          "message": { "type": "string" }
        }
      }
    }
  }
}
