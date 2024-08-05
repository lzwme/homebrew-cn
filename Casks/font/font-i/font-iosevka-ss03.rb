cask "font-iosevka-ss03" do
  version "31.1.0"
  sha256 "deeabe220280dc80a9e191c777c9eefae3f2da23b50362710feaeb7faaa7171e"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03.ttc"

  # No zap stanza required
end