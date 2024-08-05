cask "font-iosevka-ss05" do
  version "31.1.0"
  sha256 "dd32d98c9a6ae8768c3892f24af1b249dd6fb9e0669c9c837f6de0cb8573a4f2"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS05-#{version}.zip"
  name "Iosevka SS05"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS05.ttc"

  # No zap stanza required
end