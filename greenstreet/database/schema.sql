CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE trees (
    id SERIAL PRIMARY KEY,
    species VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE guardians (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    user_id INTEGER REFERENCES users(id),
    adopted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE health_reports (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(50),
    notes TEXT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
