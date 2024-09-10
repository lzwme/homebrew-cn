cask "font-iosevka-ss18" do
  version "31.6.1"
  sha256 "300c1e6098105b6b205d9d7b658704a720b5d218a05a6b5b6866de11198d01b2"

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