cask "font-iosevka" do
  version "31.7.0"
  sha256 "9be356f593282a552c2889f278c3722dc0bac7d8c1c10ce1efb3cf93bbfa4cb3"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end