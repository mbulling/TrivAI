# TrivAI

Instructions to run backend (for Windows PowerShell):

- Install Python 3.8
- `py -3.8 -m venv venv`
- `.\venv\Scripts\activate`
- `pip install --upgrade git+https://github.com/ramsrigouthamg/Questgen.ai`
- `pip install --quiet git+https://github.com/boudinfl/pke.git@69337af9f9e72a25af6d7991eaa9869f1322dd72`
- `python -m nltk.downloader universal_tagset`
- `python -m spacy download en`
- `pip install flask`
- `pip install wikipedia-api`
- `cd backend`
- `wget https://github.com/explosion/sense2vec/releases/download/v1.0.0/s2v_reddit_2015_md.tar.gz -O s2v_reddit_2015_md.tar.gz`
  - Note: This command downloads about 570 MB of data to the computer, so it will take a while to complete.
- `tar -xvf s2v_reddit_2015_md.tar.gz`
- `flask run`
