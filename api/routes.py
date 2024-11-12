from fastapi import APIRouter
from service.main_service import get_hello_message

router = APIRouter()

@router.get("/hello")
def hello():
    return {"message": get_hello_message()}
