cask "font-iosevka" do
  version "33.2.2"
  sha256 "ae0aed2bb9d4068beccc472961d943d165bb89f51a1425fca1324c5b32684736"

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