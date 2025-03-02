cask "font-iosevka" do
  version "33.0.0"
  sha256 "f74b237e4b4dfa3c01f754a9f9a0077f6517ad0922b58c78a40e782ffd28cb4e"

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