cask "nrlquaker-winbox" do
  version "3.42.0"
  sha256 "8cdeca333cef22c677ac288959faca1d7ef143a663998aa2044813538a46c2c1"

  url "https:github.comnrlquakerwinbox-macreleasesdownloadv#{version}Winbox-mac-#{version}.zip"
  name "Winbox-mac"
  desc "MikroTik Winbox"
  homepage "https:github.comnrlquakerwinbox-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Winbox-mac.app"

  zap trash: "~LibraryApplication Supportcom.mikrotik.winbox"
end