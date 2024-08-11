cask "font-iosevka-curly-slab" do
  version "31.2.0"
  sha256 "ed00b50ecac1ac401c0bdd845e9f21995e69614da116b4b394233d223f878a4b"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurlySlab-#{version}.zip"
  name "Iosevka Curly Slab"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurlySlab.ttc"

  # No zap stanza required
end