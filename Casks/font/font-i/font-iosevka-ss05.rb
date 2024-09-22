cask "font-iosevka-ss05" do
  version "31.7.0"
  sha256 "569224e380520f557c3f81ca82d0170cbf7dc6bf71b1dac13685394f1ad5a5c3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end