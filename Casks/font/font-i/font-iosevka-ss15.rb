cask "font-iosevka-ss15" do
  version "33.2.4"
  sha256 "6ea1f792574d369d07187b216ae5ecc8fac20f39cf190a64ffb17bd5b797a84f"

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