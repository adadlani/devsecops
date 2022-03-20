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
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
