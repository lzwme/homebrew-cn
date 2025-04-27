cask "font-iosevka-ss15" do
  version "33.2.2"
  sha256 "90a1e32b5367b2521e89eda7831debb7c961f73e424783b1c4bf58282957f28c"

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