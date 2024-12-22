cask "font-iosevka-ss07" do
  version "32.3.0"
  sha256 "6f81f978180386ec16af29b1c35ce020ff69c298447de9884f2b50a2d9ecac7c"

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