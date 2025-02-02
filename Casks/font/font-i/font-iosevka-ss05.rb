cask "font-iosevka-ss05" do
  version "32.5.0"
  sha256 "915e910fef025bddf02e6844cb3d532a1d198262389aa7caae255a78bf956be7"

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