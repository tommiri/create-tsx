#!/bin/bash
# Shell script for creating and initializing a TS/React project with Tailwind, Prettier and Airbnb's ESLint ruleset using yarn.

usage() {
  echo "Usage: create-tsx -n <project name>" 1>&2
  exit 1
}

while getopts ":n:" opt; do
  case "${opt}" in
  n)
    proj_name=${OPTARG}
    ;;
  *)
    usage
    ;;
  esac
done
shift $((OPTIND - 1))
if [ -z "${proj_name}" ]; then
  usage
fi

# Use vite's react-ts template to init project in given directory
yarn create vite "$proj_name" --template react-ts
cd "$proj_name" || exit

# Install dependencies
yarn

# Clean up project files
rm -rf ./public/vite.svg ./src/assets ./src/App.css

# Add tailwind to index.css
index_css='@tailwind base;
@tailwind components;
@tailwind utilities;'

echo "${index_css}" >./src/index.css

# Install peer dependencies for Airbnb's eslint config
npx install-peerdeps --dev eslint-config-airbnb -Y

# Install dependencies for eslint, prettier and tailwind
yarn add -D eslint-plugin-react@latest @typescript-eslint/eslint-plugin@latest @typescript-eslint/parser@latest eslint-config-airbnb-typescript prettier prettier-plugin-tailwindcss eslint-config-prettier eslint-plugin-prettier tailwindcss postcss autoprefixer

# Initialize tailwind for project
npx tailwindcss init -p

# Clean up App.tsx
app_content='export default function App() {
  return <h1 className="text-3xl font-bold underline">Hello world!</h1>;
}'

echo "${app_content}" >./src/App.tsx

# Clean up main.tsx
main_content="import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);"

echo "${main_content}" >./src/main.tsx

# Clean up index.html
index_content='<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>TSX + Tailwind</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>'

echo "${index_content}" >./index.html

# Setup eslintrc
eslintrc_content="module.exports = {
  env: {
    browser: true,
    es2021: true,
  },
  extends: [
    'airbnb',
    'airbnb-typescript',
    'airbnb/hooks',
    'plugin:react/recommended',
    'plugin:react/jsx-runtime',
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  overrides: [],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module',
    project: ['./tsconfig.json', './tsconfig.node.json'],
    tsconfigRootDir: __dirname,
  },
  plugins: ['react', '@typescript-eslint', 'prettier'],
  rules: {
    'react/react-in-jsx-scope': 0,
  },
};"

echo "${eslintrc_content}" >./.eslintrc.cjs

# Setup tsconfig.json
tsconfig_content='{
  "compilerOptions": {
    "target": "ES2020",
    "useDefineForClassFields": true,
    "lib": ["ES2020", "DOM", "DOM.Iterable"],
    "module": "ESNext",
    "skipLibCheck": true,

    /* Bundler mode */
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "resolveJsonModule": true,
    "isolatedModules": true,
    "noEmit": true,
    "jsx": "react-jsx",

    /* Linting */
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true
  },
  "include": [".eslintrc.cjs", "src"],
  "references": [{ "path": "./tsconfig.node.json" }]
}'
echo "${tsconfig_content}" >./tsconfig.json

# Setup tailwindconfig
tailwindconfig_content='/** @type {import("tailwindcss").Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}'

echo "${tailwindconfig_content}" >./tailwind.config.js

# Create prettierrc and set it up
touch ./.prettierrc.cjs
prettierrc_content="module.exports = {
  trailingComma: 'es5',
  tabWidth: 2,
  semi: true,
  singleQuote: true,
  plugins: ['prettier-plugin-tailwindcss'],
};"

echo "${prettierrc_content}" >./.prettierrc.cjs

# Create settings.json to fix tailwind issues
mkdir .vscode
touch ./.vscode/settings.json
settings_content='{
  "files.associations": {
    "*.css": "tailwindcss"
  },
  "editor.quickSuggestions": {
    "strings": "on"
  }
}'
echo "${settings_content}" >./.vscode/settings.json

# Create eslintignore to ignore config files
touch .eslintignore
eslintignore_content='.eslintrc.cjs
.prettierrc.cjs
vite.config.ts
*.config.js'

echo "${eslintignore_content}" >./.eslintignore

GREEN='\033[0;32m'
echo -e "${GREEN}Project initialized, happy developing!"
