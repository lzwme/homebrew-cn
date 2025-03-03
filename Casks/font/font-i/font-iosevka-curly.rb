cask "font-iosevka-curly" do
  version "33.0.1"
  sha256 "e9a9dc904d1a48c6826e9eb8fa07c642e4c186eef3606dfcc552bd34a1ef1edd"

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