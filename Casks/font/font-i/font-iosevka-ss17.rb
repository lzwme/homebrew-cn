cask "font-iosevka-ss17" do
  version "32.5.0"
  sha256 "af95f24653e3d75561c9b6d8cf0aefc05eba1f73b2000b5463eb5e9e527a747a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end