from fastapi import FastAPI, File, UploadFile, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import random
import shutil
import os
from typing import List

app = FastAPI()

# Allow CORS for local Flutter dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

CRY_TYPES = [
    {"type": "Hunger", "suggestion": "Try feeding the baby", "icon": "🍽"},
    {"type": "Colic Pain", "suggestion": "Gently massage the tummy", "icon": "🤱"},
    {"type": "Discomfort", "suggestion": "Check for tight clothes or position", "icon": "🛏"},
    {"type": "Diaper Change", "suggestion": "Check for a wet diaper", "icon": "🧼"},
    {"type": "Fever", "suggestion": "Check the baby's temperature", "icon": "🌡"},
    {"type": "Medical Emergency", "suggestion": "Seek immediate medical attention", "icon": "🚑"},
]

cry_history = []

class CryEvent(BaseModel):
    filename: str
    prediction: str
    confidence: int
    suggestion: str

@app.post("/analyze_cry")
async def analyze_cry(file: UploadFile = File(...)):
    # Save file
    save_path = f"uploads/{file.filename}"
    os.makedirs("uploads", exist_ok=True)
    with open(save_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
    # Dummy prediction
    pred = random.choice(CRY_TYPES)
    confidence = random.randint(70, 99)
    event = CryEvent(
        filename=file.filename,
        prediction=pred["type"],
        confidence=confidence,
        suggestion=pred["suggestion"]
    )
    cry_history.append(event)
    return event

@app.get("/cry_history", response_model=List[CryEvent])
def get_cry_history():
    return cry_history

@app.post("/feedback")
def feedback(filename: str = Form(...), correct: bool = Form(...)):
    # In real app, store feedback for model improvement
    return {"status": "received", "filename": filename, "correct": correct} 