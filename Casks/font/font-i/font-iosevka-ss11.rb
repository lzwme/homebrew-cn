cask "font-iosevka-ss11" do
  version "32.0.0"
  sha256 "7c146234d76089282ddf17ba66dc3a4fc37e975605fa99ce098f9901c0bdfded"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end