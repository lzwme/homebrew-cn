cask "font-iosevka-ss02" do
  version "32.3.1"
  sha256 "782d954aa230f4de7133d4fb43b1af7367bcf6b6f721928b27a294efc2729d0d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02.ttc"

  # No zap stanza required
end