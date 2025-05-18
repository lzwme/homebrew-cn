cask "font-iosevka" do
  version "33.2.3"
  sha256 "01513b40f7f81d81a17cf6362b468f00c2a986e50beb6d418be4e7e9504e80ff"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end