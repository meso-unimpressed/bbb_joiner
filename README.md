# BBB Joiner

BBB Joiner is a tiny web application which allows you to create join links to
conferences on your BBB instance. This is useful for integration into other
platforms that handle conference creation and joining but you need to be able
to invite external clients to your conference.

## Installation

Clone the git repository, copy the `.env.sample` file to `.env` and edit it to
match your setup. Then run `docker-compose up -d` or deploy it to a docker swarm
using `docker swarm deploy -c docker-compose.yml bbb_joiner`.

## Usage

To create a join link id send a `POST` request to your root url with a JSON body
of the following format:

``` json
{
  "meeting_id": "example",
  "password": "secret"
}
```

You will receive a response of the following format: 

``` json
{
  "id": "foo-bar-baz"
}
```

This id is used to assemble the join link `<root url>/<id>`. When a user follows
this link they will be presented a simple form where they can enter their name
and join the conference by submitting it.

## Expiration

Join links are stored in redis and expire by default after 24 hours. This value
can be configured by setting `LINK_TTL` in the `.env` file to the amount of
seconds a link should stay available.

## Development

Copy `.env.sample` to `.env` and run `make docker-watch` to start a dockerized
development environment which will rebuild and run on file changes.

## Contributing

1. Fork it (<https://github.com/your-github-user/bbb_joiner/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Joakim Repomaa](https://github.com/repomaa) - creator and maintainer
