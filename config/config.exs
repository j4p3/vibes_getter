import Config

config :reddit, :oauth,
    client_id: System.get_env("REDDIT_CLIENT_ID"),
    secret: System.get_env("REDDIT_CLIENT_SECRET"),
    username: System.get_env("REDDIT_USERNAME"),
    password: System.get_env("REDDIT_PASSWORD")
