cask "font-iosevka-curly-slab" do
  version "31.8.0"
  sha256 "0c9ab25d2798354780434b4fc4339b4732cceddc8aa20c993e27083abaf8262b"

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