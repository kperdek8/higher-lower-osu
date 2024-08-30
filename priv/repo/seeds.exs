# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HigherlowerOsu.Repo.insert!(%HigherlowerOsu.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HigherlowerOsu.Repo
alias HigherlowerOsu.Beatmapsets.Beatmapset

beatmapsets = [
  %{
    id: 128931,
    title: "Tower Of Heaven (You Are Slaves)",
    artist: "Feint",
    creator: "eLy",
    favourite_count: 15266,
    modes: ["osu"],
    play_count: 33127394,
    ranked: 1,
    ranked_date: ~N[2016-02-10 16:41:29]
  },
  %{
    id: 210937,
    title: "aLIEz (TV size)",
    artist: "SawanoHiroyuki[nZk]:mizuki",
    creator: "xxdeathx",
    favourite_count: 2560,
    modes: ["osu"],
    play_count: 6411280,
    ranked: 1,
    ranked_date: ~N[2014-10-26 21:40:47]
  },
  %{
    id: 277481,
    title: "To The Terminus",
    artist: "Foreground Eclipse",
    creator: "Giralda",
    favourite_count: 652,
    modes: ["osu"],
    play_count: 1863297,
    ranked: 1,
    ranked_date: ~N[2015-08-16 13:20:14]
  },
  %{
    id: 366440,
    title: "MONSTER",
    artist: "Reol",
    creator: "handsome",
    favourite_count: 6546,
    modes: ["osu"],
    play_count: 18842980,
    ranked: 1,
    ranked_date: ~N[2015-12-25 22:01:51]
  },
  %{
    id: 831738,
    title: "Resurrection",
    artist: "Seraph",
    creator: "Atalanta",
    favourite_count: 526,
    modes: ["osu"],
    play_count: 493560,
    ranked: 1,
    ranked_date: ~N[2020-02-21 10:44:55]
  },
  %{
    id: 891366,
    title: "Illusion of Inflict",
    artist: "HyuN",
    creator: "schoolboy",
    favourite_count: 3129,
    modes: ["osu"],
    play_count: 8411058,
    ranked: 1,
    ranked_date: ~N[2018-12-28 12:00:14]
  },
  %{
    id: 1112873,
    title: "image _____",
    artist: "MEMAI SIREN",
    creator: "Foxy Grandpa",
    favourite_count: 263,
    modes: ["osu"],
    play_count: 108382,
    ranked: 1,
    ranked_date: ~N[2023-01-13 13:45:29]
  },
  %{
    id: 1218852,
    title: "Yoru ni Kakeru",
    artist: "YOASOBI",
    creator: "CoLouRed GlaZeE",
    favourite_count: 23352,
    modes: ["osu"],
    play_count: 23662112,
    ranked: 1,
    ranked_date: ~N[2020-09-07 01:44:18]
  },
  %{
    id: 320905,
    title: "Max Burning!!",
    artist: "BlackY",
    creator: "SpectorDG",
    favourite_count: 391,
    modes: ["taiko", "mania"],
    play_count: 1037259,
    ranked: 1,
    ranked_date: ~N[2015-12-05 00:00:48]
  },
  %{
    id: 356147,
    title: "Dr. Wily`'`s Castle: Stage 1",
    artist: "BOSSFIGHT",
    creator: "WildOne94",
    favourite_count: 312,
    modes: ["fruits"],
    play_count: 685827,
    ranked: 1,
    ranked_date: ~N[2015-12-01 18:20:13]
  },
  %{
    id: 373414,
    title: "Spider Dance",
    artist: "toby fox",
    creator: "OzzyOzrock",
    favourite_count: 884,
    modes: ["taiko"],
    play_count: 738592,
    ranked: 1,
    ranked_date: ~N[2016-02-29 10:40:20]
  },
  %{
    id: 458825,
    title: "Day after",
    artist: "FELT",
    creator: "BennyBananas",
    favourite_count: 60,
    modes: ["fruits"],
    play_count: 20826,
    ranked: 1,
    ranked_date: ~N[2016-10-13 23:20:03]
  },
  %{
    id: 502553,
    title: "Inferno",
    artist: "9mm Parabellum Bullet",
    creator: "- Magic Bomb -",
    favourite_count: 232,
    modes: ["fruits"],
    play_count: 1009809,
    ranked: 1,
    ranked_date: ~N[2017-03-11 19:00:42]
  },
  %{
    id: 531425,
    title: "Re:End of a Dream",
    artist: "uma vs. Morimori Atsushi",
    creator: "Critical_Star",
    favourite_count: 890,
    modes: ["mania"],
    play_count: 1400647,
    ranked: 1,
    ranked_date: ~N[2017-01-14 02:00:44]
  },
  %{
    id: 538881,
    title: "Youkai no Yama ~ Mysterious Mountain",
    artist: "Demetori",
    creator: "Deif",
    favourite_count: 36,
    modes: ["fruits", "taiko"],
    play_count: 38042,
    ranked: 1,
    ranked_date: ~N[2017-06-21 01:40:05]
  },
  %{
    id: 653740,
    title: "WHITEOUT",
    artist: "Kaneko Chiharu",
    creator: "Tofu1222",
    favourite_count: 666,
    modes: ["mania"],
    play_count: 1428183,
    ranked: 1,
    ranked_date: ~N[2017-12-22 21:20:36]
  },
  %{
    id: 873024,
    title: "Jishou Mushoku",
    artist: "Hanatan",
    creator: "chickenbible",
    favourite_count: 47,
    modes: ["fruits"],
    play_count: 67140,
    ranked: 1,
    ranked_date: ~N[2019-03-25 03:20:02]
  },
  %{
    id: 931741,
    title: "Quaoar",
    artist: "Camellia",
    creator: "Nepuri",
    favourite_count: 159,
    modes: ["taiko"],
    play_count: 1247715,
    ranked: 1,
    ranked_date: ~N[2019-06-09 12:00:02]
  },
  %{
    id: 968232,
    title: "Lunatic set 15 ~ The Moon as Seen from the Shrine",
    artist: "Rin",
    creator: "MBomb",
    favourite_count: 293,
    modes: ["fruits"],
    play_count: 1038699,
    ranked: 1,
    ranked_date: ~N[2019-09-05 22:40:01]
  },
  %{
    id: 1023681,
    title: "The Ruin of Mankind",
    artist: "Inferi",
    creator: "Rhytoly",
    favourite_count: 40,
    modes: ["taiko"],
    play_count: 244476,
    ranked: 1,
    ranked_date: ~N[2019-10-07 23:21:25]
  },
  %{
    id: 1131640,
    title: "Disorder",
    artist: "HyuN feat. YURI",
    creator: "FAMoss",
    favourite_count: 542,
    modes: ["mania"],
    play_count: 441049,
    ranked: 1,
    ranked_date: ~N[2021-02-20 15:22:45]
  },
  %{
    id: 1140163,
    title: "Nhelv",
    artist: "Silentroom",
    creator: "Leniane",
    favourite_count: 726,
    modes: ["mania"],
    play_count: 678330,
    ranked: 1,
    ranked_date: ~N[2020-07-14 21:44:58]
  },
  %{
    id: 1179815,
    title: "Tempestissimo",
    artist: "t+pazolite",
    creator: "Kuo Kyoka",
    favourite_count: 2118,
    modes: ["mania", "taiko"],
    play_count: 1539920,
    ranked: 1,
    ranked_date: ~N[2021-01-14 18:25:21]
  },
  %{
    id: 1702342,
    title: "XENOViA",
    artist: "BlackY",
    creator: "Shima Rin",
    favourite_count: 124,
    modes: ["mania", "taiko"],
    play_count: 104374,
    ranked: 1,
    ranked_date: ~N[2022-07-27 03:44:54]
  }
]
Enum.each(beatmapsets, fn beatmapset ->
  Repo.insert!(Beatmapset.changeset(%Beatmapset{}, beatmapset))
end)
