cask "font-iosevka-ss16" do
  version "31.7.0"
  sha256 "612ec17b97d55868485caa28c8241ca98b8f30e9fd60330c50396406537abaad"

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