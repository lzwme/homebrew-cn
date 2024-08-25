cask "font-iosevka-ss15" do
  version "31.4.0"
  sha256 "ee766c017562da71510f7cd933349d9e1c0f9b7c776143c5fb452fd3f04d80b3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS15-#{version}.zip"
  name "Iosevka SS15"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS15.ttc"

  # No zap stanza required
end