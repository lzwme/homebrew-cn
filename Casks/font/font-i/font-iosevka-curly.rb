cask "font-iosevka-curly" do
  version "31.5.0"
  sha256 "c9cf6d2c5be7fa2856dfaea7aeb4508c74b5dfdd8463ba08ce720d846ba0c60e"

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