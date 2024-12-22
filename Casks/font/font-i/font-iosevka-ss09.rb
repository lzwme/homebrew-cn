cask "font-iosevka-ss09" do
  version "32.3.0"
  sha256 "8c7c4576fdc9b05ae2d0091a9e81d1aa3f6fa417f2f2ca5d439b4d47ee0c57e3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end