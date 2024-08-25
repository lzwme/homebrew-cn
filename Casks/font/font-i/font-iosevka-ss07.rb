cask "font-iosevka-ss07" do
  version "31.4.0"
  sha256 "ec2f99a37ff15184847d1a0625ed24cc200d25f56a12badc9856c90aea422ef7"

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