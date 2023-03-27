# Using Lambda Functions

- Log in to AWS
- Search for Lambda
- Create a Lambda function
- Edit the function and then deploy
- Search for API Gateway
- Create a new REST API by selecting Build
- Create a new resource by selecting Actions -> Create Resource in the Resources tab on the left. Give the resource a name.
- Under the endpoint that we created, click Actions -> Create Method. Choose the method you want (GET, POST, etc.)
- When setting up the method, select Lambda Function as the Integration type, check the checkbox "Use Lambda Proxy integration", and enter the lambda function created earlier.
- Click OK on the "Add Permission to Lambda Function" window
- Under the method, click "Method Request", set "API Key Required" to true.
- Deploy the API. Select "[New Stage]" for deployment stage, and give the stage a name. Click "Save Changes".
- Go to the "Usage Plans" tab on the left and create a new Usage Plan. Enter name, throttling rate, and quota. Click next.
- In "Associated API Stages", click "Add API Stage", select the API and Stage that we just created. Confirm and click next.
- Select "Create API Key and add to Usage Plan". Give the key a name and select "Autogenerate". Click next.
- Go to "API Keys" and click on the key just created. Click "Show" next to API key, and save the key somewhere.
- Go back to Lambda. Select the lambda function. There should be a button called "API Gateway" under the lambda function. Go to the configuration tab and copy the API endpoint. This is the endpoint that we're going to use in Postman.
- Create a new request on Postman with the API endpoint as the url. In the Headers tab, enter "x-api-key" as the key and the actual key (that we saved) as the value. Now we can send our request!
