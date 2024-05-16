cask "font-league-gothic" do
  version "1.601"
  sha256 "a1d9d3aaba2abda2791eaad03d51dbfd97aa6f6f2ea23c3b2b2b31f90d8cbeb5"

  url "https:github.comtheleagueofleague-gothicreleasesdownload#{version}LeagueGothic-#{version}.tar.xz",
      verified: "github.comtheleagueofleague-gothic"
  name "League Gothic"
  desc "Revival of an old classic, Alternate Gothic #1"
  homepage "https:www.theleagueofmoveabletype.comleague-gothic"

  font "LeagueGothic-#{version}staticOTFLeagueGothic-Regular.otf"
  font "LeagueGothic-#{version}staticOTFLeagueGothic-Italic.otf"
  font "LeagueGothic-#{version}staticOTFLeagueGothic-Condensed.otf"
  font "LeagueGothic-#{version}staticOTFLeagueGothic-CondensedItalic.otf"

  # No zap stanza required
end