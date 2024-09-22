cask "font-iosevka-curly" do
  version "31.7.0"
  sha256 "c683b3065ab6db6fcee5898dcebe3e25e731a6b63ddd18312c614e1ae7469204"

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