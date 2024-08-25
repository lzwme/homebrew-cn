cask "font-iosevka-curly" do
  version "31.4.0"
  sha256 "00f84530d543bc822386e38bf523ec6405d527375b85b0bfe9755086be191663"

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