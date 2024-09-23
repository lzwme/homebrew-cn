cask "font-iosevka-ss02" do
  version "31.7.1"
  sha256 "3cfd38d83a93d332b63fe09b7eb27ce8a30f723f898d957acfb780cb77bd3fe3"

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