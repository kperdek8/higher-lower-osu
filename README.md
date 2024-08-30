<a id="readme-top"></a>

<!-- PROJECT SHIELDS -->
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]



<!-- PROJECT SUMMARY -->
<div align="center">
<h3 align="center">Higher Lower Osu!</h3>

  <p align="center">
    Web game inspired by <a href=https://higherlowergame.com>Higher Lower</a> using beatmapsets from rhythm game <a href=https://osu.ppy.sh>osu!</a>.
  </p>

</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#technologies-used">Technologies Used</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#api-token">API Token</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

Higher Lower Osu! is a game where players compare the popularity of different osu! beatmap sets by guessing which one has higher or lower statistics, such as play count or favorite count. The goal is to guess correctly and see how many consecutive correct guesses you can make.

Below there is showcase of website with small samplesize of ~8 beatmapsets per game mode.

<video width="1080" height="720" controls>
  <source src="media/demo.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Technologies used

* **HTML + CSS (Tailwind)**
* **Elixir**
* **Phoenix LiveView**
* **Ecto**
* **PostgreSQL**

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started

Below are instructions to setup project locally.

### Prerequisites

Container version:
* Docker

Local version:
* Elixir
* Erlang OTP
* PostgreSQL

### Installation

#### Docker version

1. Clone the repository
   ```sh
   git clone https://github.com/kperdek8/higher-lower-osu.git
   ```
2. Navigate to project directory
    ```
    cd higher-lower-osu
    ```
3. Build and start container
    ```
    docker-compose up --build
    ```
4. Access application in your browser
    ```
    http://localhost:5000
    ```


#### Dockerless version (Elixir+PostgreSQL)

1. Clone the repository
   ```sh
   git clone https://github.com/kperdek8/higher-lower-osu.git
   ```
2. Navigate to project directory
    ```sh
    cd higher-lower-osu
    ```
3. Install Elixir dependencies
    ```
    mix deps.get
    ```
4. Make sure PostgreSQL is running

5. Prepare .env file using example
    ```sh
    cp .env.example .env
    ```
    ```sh
    nano .env
    ```
    or
    ```sh
    vim .env
    ```
6. Compile project
    ```
    mix compile
    ```
7. Set up database with custom mix task
    ```
    mix setup_database
    ```
8. Start the Phoenix server:
    ```
    mix phx.server
    ```
9. You can start IEX Shell instead to interact with backend modules:
    ```
    iex -S mix phx.server
    ```
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- API TOKEN -->
## API Token
*Note: Currently docker is setup as out-of-the-box of project showcase. If you want to manually interact with backend use dockerless setup.*

Backend requires OAuth client credentials which requires osu! account. \
Client may be generated at following link: <a href=https://osu.ppy.sh/home/account/edit#oauth>https://osu.ppy.sh/home/account/edit#oauth</a> \
Put credentials in `.env` file, check `.env.example` for variable name.

More information about API on osu!wiki: <a href=https://osu.ppy.sh/wiki/en/osu%21api>https://osu.ppy.sh/wiki/en/osu!api</a>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

### Website
- [x] Game view UI
- [x] Display beatmapsets
  - [x] Display beatmapset metadata
  - [x] Render background
  - [x] Preload backgrounds to avoid loading
  - [ ] Add animations
    - [x] Basic animations
    - [ ] Sliding animation upon correct guess
    - [ ] Better score reveal animation
  - [x] Add text style visible on any background
- [x] Guess handling
  - [x] Check correctness
  - [x] Get new beatmapset on correct guess
  - [x] Handle lose
- [x] Score counting
- [x] Add start/lose screen
  - [x] Handle transition between screens
  - [x] Criteria choice
  - [x] Gamemode choice
  - [ ] Start/lose screen UI
### Backend
- [x] Add OAuth authorization
- [x] Token cache for automatic OAuth token renewal
- [x] Implement module for making requests to osu!api
- [x] Add rate limit handling
- [x] Add queue system for API requests
- [x] Create schemas representing `Beatmap` and `Beatmapset`
- [x] Add automatic background updates for outdated beatmapsets
- [x] Add module for fetching data and inserting it into database
  - [x] Allow for batch processing
- [x] Add random beatmapset retrieval
  - [x] Add gamemode filter

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[license-shield]: https://img.shields.io/github/license/kperdek8/higher-lower-osu.svg?style=for-the-badge
[license-url]: https://github.com/kperdek8/higher-lower-osu/blob/main/LICENSE
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/krzysztof-perdek-737b32255
[product-screenshot]: images/screenshot.png
