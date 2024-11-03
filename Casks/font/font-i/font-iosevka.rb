cask "font-iosevka" do
  version "32.0.0"
  sha256 "14aa988a9c6ee225b84ae6dc48774ab9fbe62969433633c6004397d7f472f6b8"

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