### Table of Contents

-   [Important Links](#important-links)
-   [Technologies and Tools](#technologies-and-tools)
    -   [Database](#database)
    -   [Backend](#tech-backend)
        -   [Useful tools for backend](#useful-tools-for-backend)
    -   [Frontend](#tech-frontend)
        -   [Useful tools for frontend](#useful-tools-for-frontend)
-   [Database Design](#database-design)
-   [API Design](#api-design)
-   [Frontend Design](#frontend-design)
-   [Code Formatting and Linting](#code-formatting-and-linting)
    -   [Backend](#code-format-backend)
    -   [Frontend](#code-format-frontend)
    -   [Additional Notes](#code-format-additional-notes)

## Important Links

Backend Repository

-   [main branch](https://github.com/Halifax-Learning/phonetic-test-backend/):
-   [dev branch](https://github.com/Halifax-Learning/phonetic-test-backend/tree/dev): central branch to merge all the feature branches

Frontend Repository

-   [main branch](https://github.com/Halifax-Learning/phonetic-test-frontend)
-   [dev branch](https://github.com/Halifax-Learning/phonetic-test-frontend/tree/dev): central branch to merge all the feature branches

[Audio Repository](https://github.com/Halifax-Learning/audio): Repository for audio files (at the moment only contains mocked audio files)

[DB tables digram](https://app.diagrams.net/#G1PNbXyIDbN6pPMv5V23QvtA34P9FlOtFL#%7B%22pageId%22%3A%22xLGm1grYATWhj2qRU3a9%22%7D): Online version of **DB tables digram** of on draw.io

[Database Design](https://smuhalifax-my.sharepoint.com/:x:/r/personal/nghia_phan_smu_ca/Documents/Halifax%20Learning/Database%20Design.xlsx?d=w44f0395936c2400ba03d9ae51da1dd89&csf=1&web=1&e=NzHKnL): Online version of **Database Design** on OneDrive

[Figma](https://www.figma.com/design/gVGbEBJzxMAQfHa3zLkMxu/HalifaxLearning?node-id=0-1&node-type=canvas&t=GaKH62FGld4dErYt-0): Design of the frontend screens on Figma

[Note](https://smuhalifax-my.sharepoint.com/:w:/r/personal/nghia_phan_smu_ca/Documents/Halifax%20Learning/Initial%20Design.docx?d=we4d5e47e7ca6432196f866397c211754&csf=1&web=1&e=byoKLN) (OneDrive): notes on various things, include Q&As with the client

## Database Design

![DB tables diagrams](/DB%20tables%20diagram.png)

This diagram shows the relationships between the tables in the database. The online version of this diagram is on [draw.io](https://app.diagrams.net/#G1PNbXyIDbN6pPMv5V23QvtA34P9FlOtFL#%7B%22pageId%22%3A%22xLGm1grYATWhj2qRU3a9%22%7D).

For more details of each table, please refer to the [Database Design](https://smuhalifax-my.sharepoint.com/:x:/r/personal/nghia_phan_smu_ca/Documents/Halifax%20Learning/Database%20Design.xlsx?d=w44f0395936c2400ba03d9ae51da1dd89&csf=1&web=1&e=NzHKnL) on OneDrive or the [Database Design.csv](/Database%20Design.csv) on this repository.

## API Design

Refer to the [API Design](/API%20Design.md) for the details of the API endpoints.

## Frontend Design

Refer to the [Figma](https://www.figma.com/design/gVGbEBJzxMAQfHa3zLkMxu/HalifaxLearning?node-id=0-1&node-type=canvas&t=GaKH62FGld4dErYt-0) for the design of the frontend screens.

## Technologies and Tools

### Database

-   **MySQL**

### Bakend <a id="tech-backend"></a>

-   **Python**
-   **Django, Django Rest Framework**
-   **mysqlclient**
-   **bcrypt**: for hashing and verifying password

#### Useful tools for backend

-   **pylint, pylint-django**: for linting python code
-   **black**: for code formatting
-   VSCode extensions:
    -   **Pylint**: for real-time code analysis
    -   **Black**: for auto code formatting on save
    -   **REST Client**: for testing API

### Frontend <a id="tech-frontend"></a>

-   **Vite**: for building the project
-   **ReactJS**: component-based frontend library
-   **React Redux, React Redux Toolkit**: for state management
-   **React Router**: for routing
-   **TypeScript**: for type checking
-   **Material UI**: for UI components and styling
-   **Axios**: for making HTTP requests

#### Useful tools for frontend

-   **eslint**: for linting
-   VSCode extensions:
    -   **ESLint**: for real-time code analysis
    -   **prettier**: for code formatting
-   Browser extensions:
    -   **React Developer Tools**: for debugging React components
    -   **Redux DevTools**: for debugging Redux state

## Code Formatting and Linting

### Backend <a id="code-format-backend"></a>

Install `pylint`, `pylint-django`, `black`:

```bash
pip install pylint pylint-django black
```

To run `pylint`:

```bash
pylint phonetic_test_backend phonetic_test <any_additional_folder>
```

It will analyze the code in the specified folders and give the warnings and errors.

To run `black` formatter:

```bash
black .
```

It will format all the files in the current directory (we will not really use this command, because we will use the VSCode extension).

<br>

In VSCode, install `Pylint` extension for real-time code analysis.

Install `Black` extension for auto code formatting on save. Add the following to `settings.json`:

```json
    "[python]": {
        "editor.defaultFormatter": "ms-python.black-formatter"
    },
    "black-formatter.args": [
        "--line-length=100"
    ],
    "editor.formatOnSave": true,
```

### Frontend <a id="code-format-frontend"></a>

`eslint` and `prettier` are already installed when running `npm install`.

To run `eslint`:

```bash
npm run lint
# or
npx eslint .
```

It will analyze the code in the current directory and give the warnings and errors.

To run `prettier`:

```bash
npm run prettier
# or
npx prettier --write src
```

It will format all the files in the `src` directory based on the rules specified in `.prettierrc` file (we will not really use this command, because we will use the VSCode extension).

<br>

In VSCode, install `ESLint` extension for real-time code analysis.

Install `Prettier` extension for auto code formatting on save. Add the following to `settings.json`:

```json
    "[javascript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[javascriptreact]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[typescript]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[typescriptreact]": {
        "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "editor.formatOnSave": true,
```

### Additional Notes <a id="code-format-additional-notes"></a>

-   Use lf (Unix) line endings for all files
-   Use 4 spaces (not tab) for indentation
