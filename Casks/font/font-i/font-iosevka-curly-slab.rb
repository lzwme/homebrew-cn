cask "font-iosevka-curly-slab" do
  version "32.5.0"
  sha256 "04bc258b1c3e1b598dd21fcefb422bc6bb1e1852b74fec725b5ff72d7f723d88"

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