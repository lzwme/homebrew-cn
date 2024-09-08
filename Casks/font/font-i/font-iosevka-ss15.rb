cask "font-iosevka-ss15" do
  version "31.6.0"
  sha256 "bbc98b0415e1013720daed8f42eacf1f475d65c44b09b769106ad6713abd8341"

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