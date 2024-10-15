cask "font-iosevka-ss15" do
  version "31.9.1"
  sha256 "405e784b355706ddeddeda8d5726d010f8fe81a213d08aea060ac22e7129224b"

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