cask "font-iosevka-ss08" do
  version "32.3.0"
  sha256 "cba9f2791e2576ca8a05f8bba4286efeeecfea63e2ec3715d4a6c700f45af63b"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end