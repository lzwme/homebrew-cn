cask "font-iosevka" do
  version "31.9.1"
  sha256 "fab599f41be6a3931812b4da4876f6c9032e7b5bc5fdf7704a7662f707bcd151"

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