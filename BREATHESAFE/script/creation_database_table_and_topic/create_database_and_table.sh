#!/bin/bash

# Nom de la base de données à vérifier
DB_NAME="DataBase_Polluants"
DB_USER="surelmanda"

# Liste des tables à créer
TABLES=("aggregated_data")

# Vérifier si la base de données existe
EXISTING_DB=$(psql -lqt -U $DB_USER | cut -d \| -f 1 | grep -w $DB_NAME)

# Supprimer la base de données si elle existe
if [ -n "$EXISTING_DB" ]; then
  dropdb -U $DB_USER $DB_NAME
  echo "La base de données $DB_NAME existait et a été supprimée."
fi

# Créer la base de données
createdb -U $DB_USER $DB_NAME
echo "La base de données $DB_NAME a été créée avec succès."

# Traiter chaque table
for TABLE_NAME in "${TABLES[@]}"; do
  # Supprimer la table si elle existe
  psql -U $DB_USER -d $DB_NAME -c "DROP TABLE IF EXISTS $TABLE_NAME CASCADE;"

  # Charger la structure de la table depuis le fichier SQL
  psql -U $DB_USER -d $DB_NAME -f "/Users/surelmanda/Downloads/AirGUARD/BREATHESAFE/Script/tables/${TABLE_NAME}.sql"
  echo "La table $TABLE_NAME a été crée avec succès."
done

# Message d'achèvement
echo "L'exécution du script est terminée."