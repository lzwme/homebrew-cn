cask "font-iosevka-curly" do
  version "31.9.0"
  sha256 "279458801a1ef81f5ab49df54d7ee037d42e120bbf818b0ae0deaf259f2e43e3"

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