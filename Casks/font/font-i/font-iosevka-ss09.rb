cask "font-iosevka-ss09" do
  version "33.2.6"
  sha256 "162d90f7fed784ccdafa7bae7bc691876b6d9c25cd677f31ee6bcfd13388f2fc"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS09-#{version}.zip"
  name "Iosevka SS09"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS09.ttc"

  # No zap stanza required
end