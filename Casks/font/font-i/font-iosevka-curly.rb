cask "font-iosevka-curly" do
  version "32.2.0"
  sha256 "02752bd7cca7557e917a24a51ff994f42b71b6169bc5de811b937ee9e71a0e8f"

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