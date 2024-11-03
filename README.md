### Table of Contents

-   [Important Links](#important-links)
-   [Database Design](#database-design)
-   [Backend](#backend)
    -   [API Design](#api-design)
    -   [Query Optimization](#query-optimization)
    -   [Audio Files](#audio-files)
    -   [Audio Matching Model](#audio-matching-model)
-   [Frontend Design](#frontend-design)
-   [Deployment](#deployment)
-   [Technologies and Tools](#technologies-and-tools)
    -   [Database](#database)
    -   [Backend](#tech-backend)
        -   [Useful tools for backend](#useful-tools-for-backend)
    -   [Frontend](#tech-frontend)
        -   [Useful tools for frontend](#useful-tools-for-frontend)
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

## Backend

### API Design

Refer to the [API Design](/API%20Design.md) for the details of the API endpoints.

### Query Optimization

To improve query performance and database integrity, several optimizations were implemented:

-   **Efficient Data Retrieval**: Using select_related() and prefetch_related() in Django, join operations are performed when retrieving data across related tables, reducing the number of separate database calls.

-   **Bulk Operations**: For creating and updating multiple records, bulk_create() and bulk_update() were used, which minimizes the number of queries required for these tasks.

-   **Atomic Transactions**: To ensure database integrity, all database write operations for each API are grouped within an atomic transaction. This setup guarantees that either all operations are completed or none are, preserving data consistency.

### Audio Files

All audio files are stored on the file system of the SMU server, with only file paths saved in the database tables. These files are retrieved via the GET /api/audio/{test_id} API, which provides audio files for a test. Several key optimizations ensure efficient and secure audio handling:

-   **Audio Processing**: The original files from HLC are in AIFC format, which, while high-quality, is large and not universally compatible with browsers. To address this:

    -   **Format Conversion**: Files are converted to MP3 with a 128 kbps bitrate to reduce size while preserving good quality and ensuring compatibility with major browsers.

    -   **Silence Trimming**: Silence at the beginning and end of each file is trimmed.

    -   **Volume Normalization**: Volume levels are normalized to maintain consistent audio quality across files.

-   **Batch Retrieval**: Instead of sending separate requests for each question’s audio, all files for a test (e.g., instructions, questions, answers) are fetched in a single request. The backend bundles these files into a zip archive, which is returned as binary data. This method minimizes backend requests and database queries while keeping the total file size manageable (under 5 MB) for fast loading.

-   **Security**: The API never exposes file paths. Instead, it only requires the test ID in the request, returning files as binary data in the response, which helps maintain application security.

### Audio Matching Model

The application uses the pretrained model [facebook/wav2vec2-xlsr-53-espeak-cv-ft](#https://huggingface.co/facebook/wav2vec2-xlsr-53-espeak-cv-ft) to evaluate student responses. This model transcribes an audio file into phonemes using the International Phonetic Alphabet (IPA). The transcription of a student's answer is compared against the correct answer’s phoneme transcription, yielding a similarity score between 0 and 100. An answer is marked as correct if it achieves a similarity score of 60% or higher.

To handle the resource-intensive nature of running this model—which can take several seconds per audio file—the audio analysis tasks are processed in the background. Celery, in combination with RabbitMQ as the message broker, manages this asynchronous task execution. Once the final question of an assessment is submitted, the task begins processing and evaluates each question in the assessment. This approach ensures efficient use of server resources and smoother user experience.

## Frontend Design

Refer to the [Figma](https://www.figma.com/design/gVGbEBJzxMAQfHa3zLkMxu/HalifaxLearning?node-id=0-1&node-type=canvas&t=GaKH62FGld4dErYt-0) for the design of the frontend screens.

## Deployment

The application is deployed on SMU server using Docker containers, organized as follows:

• **Certbot**: Handles the SSL certificate generation and renewal for HTTPS, ensuring secure communication between the client and server.

• **Backend**: Runs the Django application and Celery tasks, responsible for API requests, background audio analysis tasks, and database interactions.

• **Frontend**: Hosts the React application, serving the user interface accessible to students, teachers, and admins.

• **RabbitMQ**: Acts as the message broker, managing task queues for Celery to enable asynchronous processing of background tasks like audio analysis.

## Technologies and Tools

### Database

-   **MySQL**

### Bakend <a id="tech-backend"></a>

-   **Python**
-   **Django, Django Rest Framework**
-   **mysqlclient**
-   **bcrypt**: for hashing and verifying password
-   **PyJWT**: for generating and verifying JWT tokens

#### Useful tools for backend

-   **pylint, pylint-django**: for linting python code
-   **black**: for code formatting
-   **django-sqlformatter**: for formatting SQL queries in logs
-   VSCode extensions:
    -   **Pylint**: for real-time code analysis
    -   **Black**: for auto code formatting on save
    -   **isort**: for sorting imports for python files
    -   **REST Client**: for testing API

### Frontend <a id="tech-frontend"></a>

-   **Vite**: for building the project
-   **ReactJS**: component-based frontend library
-   **React Redux, React Redux Toolkit**: for state management
-   **React Router**: for routing
-   **React Media Recorder**: for managing audio recording
-   **TypeScript**: for type checking
-   **Material UI**: for UI components and styling
-   **Axios**: for making HTTP requests
-   **Yup**: for form validation
-   **Jszip**: for zipping and unzipping files

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

Tips:

-   Use `Organize Imports` command in VSCode to sort imports for python files (requires `isort` extension).

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

Tips:

-   Use `Organize Imports` command in VSCode to sort and remove unused imports.
-   Sometimes, prettier auto-formatting rules might conflix with eslint rules. Use `// prettier-ignore` to ignore the next line from prettier formatting.

### Additional Notes <a id="code-format-additional-notes"></a>

-   Use lf (Unix) line endings for all files
-   Use 4 spaces (not tab) for indentation
