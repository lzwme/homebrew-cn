cask "font-iosevka-aile" do
  version "31.7.0"
  sha256 "ea525bc084e0f25d4fa6d3b2748bf2dabc482aa6cf22cab8349651af4aa1f994"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end