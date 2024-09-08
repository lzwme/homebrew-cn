cask "font-iosevka-ss09" do
  version "31.6.0"
  sha256 "34056ddbd90c23e1c69c0bf5c18ef8708a4735c104bc7d125d5bd9aa8aaff9dc"

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