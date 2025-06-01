cask "font-iosevka-ss16" do
  version "33.2.4"
  sha256 "d710af4b9451260e3c90c94f2699917e92c2dc39d47839892517e286d5b8d227"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end