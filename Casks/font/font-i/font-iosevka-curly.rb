cask "font-iosevka-curly" do
  version "32.2.1"
  sha256 "f2aa2b435cefcaba2edefe0556a385d6634ab4f05b18410353214e341f45d0cb"

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