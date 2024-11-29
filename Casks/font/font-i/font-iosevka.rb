cask "font-iosevka" do
  version "32.2.0"
  sha256 "81651ba2e9b5402f3298094532cb3c3a00d7f2189dc8d831cb18a5eecbb6da8e"

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