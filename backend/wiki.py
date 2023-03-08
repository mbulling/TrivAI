import wikipediaapi
from typing import Optional


def get_summary(topic: str) -> Optional[str]:
    wiki = wikipediaapi.Wikipedia('en')
    ''' Gets the Wikipedia summary of the given topic '''
    page = wiki.page(topic)  # TODO Capitalization
    if page.exists():
        return page.summary
    else:
        return None
