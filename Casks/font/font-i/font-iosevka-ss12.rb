cask "font-iosevka-ss12" do
  version "31.5.0"
  sha256 "d3a5c8d5ad277f79d2d50faacac6bf5120a8726eb79a7690e5728139e7809ee2"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12.ttc"

  # No zap stanza required
end