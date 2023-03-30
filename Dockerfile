# Builder image
FROM node:18-alpine as build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json dans le répertoire de travail
COPY package*.json ./

# Installer les dépendances
RUN npm install
# Copier tous les fichiers du projet dans le répertoire de travail
COPY . .

# Compiler l'application React
RUN npm run build

# Etape 2 : Serveur web pour l'application
FROM nginx:alpine

# Copier le fichier de configuration pour Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers de l'application React dans le répertoire de publication de Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx"]


ENTRYPOINT ["top", "-b"]