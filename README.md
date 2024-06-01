# TSX + Tailwind Project Initializer

This is a bash script for creating and initializing a TypeScript/React project with Tailwind, Prettier, and Airbnb's ESLint ruleset. The script uses yarn to install dependencies.

## What it Does

1. Uses Vite's react-ts template to initialize a new project in the given directory.
2. Installs the necessary dependencies.
3. Cleans up the project files.
4. Adds Tailwind to the project's index.css file.
5. Installs peer dependencies for Airbnb's eslint config.
6. Installs dependencies for eslint, prettier, and tailwind.

## Installation

To install this script, you should place it in your `/usr/local/bin` directory. This will allow you to run the script from anywhere on your system. Here's how you can do it:

```sh
sudo cp create-tsx.sh /usr/local/bin/create-tsx
sudo chmod +x /usr/local/bin/create-tsx
```

The first command copies the script to `/usr/local/bin` and renames it to `create-tsx`. The second command makes the script executable.

Now you can use the script from anywhere on your system by typing `create-tsx`.

Please ensure you have `yarn` installed before running this script.

## Usage

To use this script, you can run it with the `-n` option followed by your project name. If you want to use the current directory, you can use `.` as the project name.

```sh
create-tsx -n <project name>
```

For example, to create a new project in the current directory:

```sh
create-tsx -n .
```
