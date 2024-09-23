cask "font-iosevka-ss10" do
  version "31.7.1"
  sha256 "6d874d622b43bf1ecb5d9ac9fcd6badebf58e58f34ee5943bdaecf0dde0432e3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS10-#{version}.zip"
  name "Iosevka SS10"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS10.ttc"

  # No zap stanza required
end