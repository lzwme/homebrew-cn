cask "font-iosevka-ss06" do
  version "32.2.0"
  sha256 "f25d051436365ea988cfb292bab130879a885f242fc247d6edd86e1bc91eb85a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS06-#{version}.zip"
  name "Iosevka SS06"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS06.ttc"

  # No zap stanza required
end