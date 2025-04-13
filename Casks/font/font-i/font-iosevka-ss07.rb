cask "font-iosevka-ss07" do
  version "33.2.1"
  sha256 "e32f03b4efd6ee0a97537210356169107b37ba94199cdd0fb96c42c42c22be9a"

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