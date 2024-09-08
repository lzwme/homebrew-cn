cask "font-iosevka-curly" do
  version "31.6.0"
  sha256 "a2a7bf483da1108e9bc44f9ddd33c01b8ea5357debbc703356674db2bbbf17cd"

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