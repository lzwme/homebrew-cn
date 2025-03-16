cask "font-iosevka-ss11" do
  version "33.1.0"
  sha256 "1a78f4d9133e9e1bba7add5231af41283d18394e96149594c6a3b3fcab6cc3af"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS11-#{version}.zip"
  name "Iosevka SS11"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS11.ttc"

  # No zap stanza required
end