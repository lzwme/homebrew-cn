cask "font-iosevka-curly" do
  version "32.0.0"
  sha256 "ee069ae71efae8db36156fa09075734d0dba23da8ee7c5c766a684bdae7316ca"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaCurly-#{version}.zip"
  name "Iosevka Curly"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaCurly.ttc"

  # No zap stanza required
end