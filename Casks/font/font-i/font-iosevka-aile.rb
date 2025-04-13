cask "font-iosevka-aile" do
  version "33.2.1"
  sha256 "ff04a5adfbc3dab7f27a6814099090f651eb468af5aef6e660b79248f8f87a6c"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end