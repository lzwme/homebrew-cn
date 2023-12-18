cask "landrop" do
  version "0.4.0"
  sha256 "069f7ce4d43647a8e968de77ae1dd277e984d6ded6bf7cdac5caf979a7ac7123"

  url "https:github.comLANDropLANDropreleasesdownloadv#{version}LANDrop-#{version}-macos.dmg",
      verified: "github.comLANDropLANDrop"
  name "LANDrop"
  desc "Drop any files to any devices on your LAN"
  homepage "https:landrop.app"

  app "LANDrop.app"

  uninstall quit: "app.landrop.landrop"

  zap trash: "~LibraryPreferencesapp.landrop.landrop.plist"
end