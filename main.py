import os
from urllib.parse import quote_plus
import psycopg2
from dotenv import load_dotenv
import pandas as pd
from sqlalchemy import create_engine

#Chargement des variables d’environnement
load_dotenv()
db_name = os.getenv("DB_NAME")
db_user = os.getenv("DB_USER")
db_pass = quote_plus(os.environ['DB_PASSWORD'])
db_host = os.getenv("DB_HOST")
db_port = os.getenv("DB_PORT")

#Création de connexion
conn = psycopg2.connect(database = db_name,user = db_user,host= db_host,password = db_pass,port = db_port)

cur = conn.cursor()

# Execution requetes SQL pour recuperer la version
cur.execute("SELECT version();")

# Fetch le resultat
version = cur.fetchone()[0]
print(f"PostgreSQL Version (via SELECT version()): {version}")

#imortation des données
try:
    data = pd.read_excel("london_bikes_final.xlsx",sheet_name="Londres")
except any as e:
    print("Probleme dans le chargement des données")
    print(e)
    exit(1)

print(data.columns)

#Creation Moteur Sql
engine = create_engine(f'postgresql+psycopg2://{db_user}:{db_pass}@{db_host}/{db_name}')

engine.connect()

#Mogration de data
data.to_sql("london_bikes_final", con=engine, if_exists='replace', index=False)

engine.dispose()

#Vérification

cur.execute("SELECT COUNT(*) FROM london_bikes_final")
result = cur.fetchone()
print(f'{result[0]} lignes etaits affectés')

cur.close()
conn.close()
