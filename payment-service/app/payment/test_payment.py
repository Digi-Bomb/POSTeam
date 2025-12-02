from app import create_app

app = create_app()
client = app.test_client()

def test_health():
    res = client.get("/health")
    assert res.status_code == 200
    assert res.get_json()["status"] == "ok"

def test_quote():
    res = client.post("/api/payment/quote")
    data = res.get_json()
    assert res.status_code == 200
    assert "total" in data
    assert data["currency"] == "USD"

def test_authorize():
    res = client.post("/api/payment/authorize", json={"orderId": "ORD-1", "total": 34.99})
    data = res.get_json()
    assert res.status_code == 200
    assert data["status"] == "AUTHORIZED"
    assert "authorizationId" in data

def test_cancel():
    # First authorize an order so it exists
    client.post("/api/payment/authorize", json={"orderId": "ORD-2", "total": 10.00})

    # Then cancel it
    res = client.post("/api/payment/cancel", json={"orderId": "ORD-2"})
    data = res.get_json()

    assert res.status_code == 200
    assert data["status"] == "CANCELED"
    assert data["orderId"] == "ORD-2"