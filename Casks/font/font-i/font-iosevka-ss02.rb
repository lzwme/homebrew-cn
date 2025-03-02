cask "font-iosevka-ss02" do
  version "33.0.0"
  sha256 "6e2459f59a842f8664a2c501a90ec04627d6badbbee632ac1afc482c60ede161"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02.ttc"

  # No zap stanza required
end