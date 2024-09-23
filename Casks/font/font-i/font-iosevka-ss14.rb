cask "font-iosevka-ss14" do
  version "31.7.1"
  sha256 "690b21959398acd37e418ed734b24c71d37d6a5308c447f2b451f78745af71fa"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS14-#{version}.zip"
  name "Iosevka SS14"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS14.ttc"

  # No zap stanza required
end