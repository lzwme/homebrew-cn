cask "font-iosevka-ss17" do
  version "33.2.0"
  sha256 "c4aab131330510ed55aa1e7987ce1e9db159aa7967e0d0dcf6a29301a4e1b9bf"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17.ttc"

  # No zap stanza required
end