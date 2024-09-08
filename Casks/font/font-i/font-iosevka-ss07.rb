cask "font-iosevka-ss07" do
  version "31.6.0"
  sha256 "22723aa1b8d28c54eb5a304216bc84e0cebe35af5699d872061c6eb403fc5b68"

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