cask "font-iosevka-ss01" do
  version "33.2.5"
  sha256 "0c394c91cb9fa4da045f4cdea27d5023a6d30202a7c6aa3fcfb9961b3d676508"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01.ttc"

  # No zap stanza required
end