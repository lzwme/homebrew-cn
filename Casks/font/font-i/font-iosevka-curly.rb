cask "font-iosevka-curly" do
  version "33.1.0"
  sha256 "c8521f59621ed1bcec45bb7985d030e87c80169224f0290adfd001a765801f87"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurly-#{version}.zip"
  name "Iosevka Curly"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurly.ttc"

  # No zap stanza required
end