cask "font-iosevka-curly" do
  version "31.2.0"
  sha256 "716d0bc010a6f87e39e1aa003fc155df4f728663c8fa16338e3a8f87dd17344c"

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