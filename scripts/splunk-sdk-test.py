import splunklib.client as client
from dotenv import load_dotenv
import os


def main():
    try:
        load_dotenv()
        username = os.environ.get('username')
        password = os.environ.get('password')
        host = os.environ.get('splunk-host')
        port = '8089'
        owner = os.environ.get('splunk-owner')
        app = 'search'
        sharing = 'user'
        service = client.connect(username=username, password=password,
                                 host=host, port=port, owner=owner, app=app,
                                 sharing=sharing)

        if service:
            print("Splunk connection successfull")

            # Execute a few API calls
            
            # Return info about server
            print(service.info) # Return type dictionary with key-value pairs

            # Return all indexes (collection)
            for index in service.indexes:
                print(index.name)

            # Return all saved searches
            saved_searches = service.saved_searches
            for search in saved_searches:
                print(search.name)

            
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
