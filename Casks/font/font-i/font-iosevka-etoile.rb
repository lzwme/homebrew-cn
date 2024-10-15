cask "font-iosevka-etoile" do
  version "31.9.1"
  sha256 "fdf7f4ee2499b53ecde53927ca4c34a9d0aa72823165dba54a1283df1ffa2609"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"

  # No zap stanza required
end