cask "font-iosevka-ss04" do
  version "31.5.0"
  sha256 "e8b03011bc15b4d5a15cd15ebc07ef5104dbbb7c49f4f460d1fe714c55fab042"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaSS04-#{version}.zip"
  name "Iosevka SS04"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS04.ttc"

  # No zap stanza required
end