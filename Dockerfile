# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Use the Node.js image
FROM node:18-alpine AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY src ./src
COPY tsconfig.json ./

# Build the TypeScript code
RUN npm run build

# Use a smaller node image for the final build
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy the build from the builder stage
COPY --from=builder /app/build ./build
COPY package.json ./

# Set environment variables for Spotify API
ENV SPOTIFY_CLIENT_ID=your_client_id
ENV SPOTIFY_CLIENT_SECRET=your_client_secret

# Run the MCP server
ENTRYPOINT ["node", "build/index.js"]