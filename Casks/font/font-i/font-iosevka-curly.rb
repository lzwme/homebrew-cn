cask "font-iosevka-curly" do
  version "33.2.6"
  sha256 "8187170dcd82e0afc73b709f37e16da6f6d703242683c55322059bd058a9ee2a"

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