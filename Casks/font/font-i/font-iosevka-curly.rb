cask "font-iosevka-curly" do
  version "33.2.1"
  sha256 "ce25b0078e2fac9c66a9888a8d15323ebd9fbd6a608f5d6c0ec822a5e38561ea"

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