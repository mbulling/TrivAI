# TrivAI

TrivAI is an iOS app that allows users to generate quizzes based on any topic. The app is built using Xcode and connects to a Flask backend that utilizes the OpenAI API.

## Getting Started

### Prerequisites

To run the app locally, you will need to have the following:

- Xcode (version 13.2 or later)
- Python (version 3.8 or later)
- OpenAI API key

### Installing

1. Clone this repository to your local machine.
2. Navigate to the `backend` directory and install the required Python packages by running the following command:

      ```pip install -r requirements.txt```


3. Set up your OpenAI API key by following the instructions in the [OpenAI API documentation](https://beta.openai.com/docs/api-reference/authentication).
4. In the `backend` directory, create a `secrets.py` file and add your OpenAI API key as follows:

    ```OPENAI_API_KEY=<your-api-key-here>```


### Running the App

1. Open the `TrivAI.xcworkspace` file in Xcode.
2. Build and run the app on your desired device or simulator.
3. Use the app to generate quizzes and test your knowledge!

## Contributing

If you would like to contribute to this project, please follow these steps:

1. Fork this repository.
2. Create a new branch with your proposed changes.
3. Commit and push your changes to your fork.
4. Submit a pull request describing your changes and their purpose.

## License

This project is licensed under the MIT License - see the `LICENSE` file for details.







