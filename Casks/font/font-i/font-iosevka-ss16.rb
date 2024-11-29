cask "font-iosevka-ss16" do
  version "32.2.0"
  sha256 "c5c8d87a134a58f826b10e4d02672febb4393e7f7dbc6f0bc5bf84c599c3ba47"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS16-#{version}.zip"
  name "Iosevka SS16"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS16.ttc"

  # No zap stanza required
end