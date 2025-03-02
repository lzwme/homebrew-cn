cask "font-iosevka-ss05" do
  version "33.0.0"
  sha256 "4e4e5d50f9f4b9ebba8cc87dfe9c90091517fe8f3456acc25d98800fae3f373a"

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