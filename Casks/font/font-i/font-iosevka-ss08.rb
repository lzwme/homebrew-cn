cask "font-iosevka-ss08" do
  version "32.2.1"
  sha256 "71b090f3f4f7b84e3ee15dd471bc3b130440431b68f3d26bcd8c4b008a752370"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end