
# TrivAI

Front-end branch

## Description

TrivAI is a CDS backend project using SwiftUI/Swift and NLP models to create a ML powered version of Quizlet

## Getting Started

### Dependencies

* Describe any prerequisites, libraries, OS version, etc., needed before installing program.
* ex. Windows 10

### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Executing program

* Instructions to run backend (for Windows PowerShell) [backend]:

- Install Python 3.8
- `py -3.8 -m venv venv`
- `.\venv\Scripts\activate`
- `pip install -r requirements.txt`
- `cd backend`
- `wget https://github.com/explosion/sense2vec/releases/download/v1.0.0/s2v_reddit_2015_md.tar.gz -O s2v_reddit_2015_md.tar.gz`
  - Note: This command downloads about 570 MB of data to the computer, so it will take a while to complete.
- `tar -xvf s2v_reddit_2015_md.tar.gz`
- `flask run`

## Help

Any advise for common problems or issues.

* Try Mason's master requirements.txt file
* Delete ```hinglish```

## Authors

Contributors names and contact info

Mason Bulling
Lisa Li
James Zhang
Vivian Chen
Abby Kim
Iram Liu
Eric Zhang
Kenneth Chiem

## Version History

* 0.2
    * Created front-end linked to Quiz view (no database integration)
* 0.1
    * First scratch front-end

