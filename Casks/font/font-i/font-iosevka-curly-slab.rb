cask "font-iosevka-curly-slab" do
  version "32.0.1"
  sha256 "07836e1fd197170e7b4d6cafdfad0c4405069cb9819f864b82115ba137b765ab"

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