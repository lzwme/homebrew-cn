cask "font-iosevka-aile" do
  version "31.4.0"
  sha256 "fee9a97440f5151e64b46cb315766337a2eb860efad0d61e8686d54db1bc705d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end