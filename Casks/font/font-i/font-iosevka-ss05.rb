cask "font-iosevka-ss05" do
  version "31.7.1"
  sha256 "aa2e7ac4cdc67e2561ef4589d24a171b6d849b752b0bec5fc3c14d5432f72ae1"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end