cask "font-iosevka-ss07" do
  version "33.2.2"
  sha256 "619baf8eb5d8a0d04683ad82c5b917a04e1bf972b829a864124b6b04d9162b94"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end