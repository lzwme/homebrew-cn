cask "font-iosevka" do
  version "33.2.4"
  sha256 "e19e4291f874c3a5dbb68221a86cae5a96c4f2866a17668b5981df9dc7e7d97f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end