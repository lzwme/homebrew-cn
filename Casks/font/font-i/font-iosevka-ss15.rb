cask "font-iosevka-ss15" do
  version "31.3.0"
  sha256 "a1ce648f4daae6d2ec4fd0f3c524e29204cd26df218656dea75da81771e8ba4e"

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