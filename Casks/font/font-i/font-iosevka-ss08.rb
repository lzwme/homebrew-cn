cask "font-iosevka-ss08" do
  version "31.3.0"
  sha256 "4d8ec79fa7c81f5b5d67a166d2a8487f199cf569b540924565273bf66f1c6d13"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08.ttc"

  # No zap stanza required
end