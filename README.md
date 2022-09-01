## Sinatra IMC/BMI API

That's simple API to calculate IMC/BMI given weight and height into authenticated POST route using JWT. That API was build in Sinatra because simple complexity and because I never used that before

## Running this project

  - Install [Docker Engine and Docker-Compose](https://docs.docker.com/engine/install/)
  - Rename `.env-example` for `.env`
  - Execute on project's directory:
    - `$ docker build -t imc .`
    - `$ docker run --rm -it -p 3000:3000 imc`

  - Or if your perfer running with local dependences:
    - `$ bundle exec rackup --host 0.0.0.0 -p 3000`
    - > Keep in mind dependence versions:
      > - Ruby 3.1.2
      > - Bundler 2.3.7


## Environment Variables

- **INNER_AUTH**: Like a password service, it's up to you setting whatever value you want. Pass this value in body on `POST /login` for getting token generation, like that:
  ```json
  {
      "inner_token": "RHST"
  }
  ```
- **SESSION_SECRET**: Session cookies encrypt token, it's up to you setting whatever value you want.

## Routes

- `GET /status`
  ```json
    // Response
    {
      "status": "up",
      "version": 1
    }
  ```

- `POST /login`: *Here you can get credentials passing correct inner_auth*
  ```json
    // request
    {
      "inner_token": "RHST"
    }

    // Response
    {
      "message": "Logged",
      "token": ...
    }
  ```

- `POST /imc`: *Here you can calculate IMC*
    [reference](https://images.theconversation.com/files/349366/original/file-20200724-25-osy3a3.PNG?ixlib=rb-1.1.0&q=45&auto=format&w=754&h=382&fit=crop&dpr=1)

  ```json
    // request header
    {
      "access_token": "<token_generated>"
    }
    // request body
    {
      "height": 1.30, // > 0.0 && Float
      "weight": 50 // > 0 && Integer
    }

    // Response
    {
      "imc": 29.6, // Kg/m^2
      "classification": "Overweight situation",
      "obesity": "-"
    }
  ```
- `GET /logout` *Here you can finish session saved before*
  ```json
    {
      "message": "Session end successfuly"
    }
  ```

