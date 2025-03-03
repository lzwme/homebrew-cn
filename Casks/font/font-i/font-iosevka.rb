cask "font-iosevka" do
  version "33.0.1"
  sha256 "303dcfca7e7cb309bd84c4dacb61514a13f64ef79ce112f572d635b7026eb6ad"

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