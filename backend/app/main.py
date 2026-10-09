from fastapi import FastAPI

app = FastAPI(title="ASiPSS API")


@app.get("/api/health")
def health():
    return {"status": "ok"}
