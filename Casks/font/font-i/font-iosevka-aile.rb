cask "font-iosevka-aile" do
  version "31.6.1"
  sha256 "785a6634e295e54fbe414426549f259fe4318dec33152d3e58ba760e6fad1c88"

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