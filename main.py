from fastapi import FastAPI
from api.routes import router

app = FastAPI()

# Include API routes
app.include_router(router)

# Basic Hello World route
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}