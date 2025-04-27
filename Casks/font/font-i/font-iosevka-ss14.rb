cask "font-iosevka-ss14" do
  version "33.2.2"
  sha256 "f03b8e6cf83566c20c9737f2f89e5cb29178aff20657ac7c275ca98c467825b2"

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