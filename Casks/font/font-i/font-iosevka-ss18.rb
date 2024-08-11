cask "font-iosevka-ss18" do
  version "31.2.0"
  sha256 "cb13cf64d8e899f81d8eceb3f5985626b058c06b010b73230e1c0d813f94b740"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18.ttc"

  # No zap stanza required
end