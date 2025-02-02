cask "font-iosevka-ss07" do
  version "32.5.0"
  sha256 "2cbc3de3aef4a9a7f7b5c316d32bf95203f7b8b1dab6ec49df6a5d9694986443"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS07-#{version}.zip"
  name "Iosevka SS07"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS07.ttc"

  # No zap stanza required
end