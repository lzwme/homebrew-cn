cask "font-iosevka-ss08" do
  version "31.7.0"
  sha256 "e78425d8a7fa6eb6e59f4be939810fabaee60ba312c9c06d0de40d2a56204b6f"

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