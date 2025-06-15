cask "font-iosevka-ss17" do
  version "33.2.5"
  sha256 "77e0fec6efe793da34d5418a6b19bbbb5958527d167109e67aed93fc047c594e"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end