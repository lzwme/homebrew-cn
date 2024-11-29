cask "font-iosevka-ss12" do
  version "32.2.0"
  sha256 "62cbf1ffe88283a977cacb778dd1af6249954131918c1fe83aeb620f939236a1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end