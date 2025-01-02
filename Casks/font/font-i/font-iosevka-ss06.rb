cask "font-iosevka-ss06" do
  version "32.3.1"
  sha256 "6fdef925fdc0a67ce8e75629a67f07e3a62f14d2d4da313bc97b61e8d549a6b9"

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