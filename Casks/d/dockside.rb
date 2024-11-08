cask "dockside" do
  version "1.7.3"
  sha256 "018a3fd72014f1ea65827d5fddf5d30482392c462622773ea3823aafb1d79a10"

  url "https:github.comPrajwalSDDocksidereleasesdownloadv#{version}Dockside.dmg",
      verified: "github.comPrajwalSDDockside"
  name "Dockside"
  desc "Dock utility"
  homepage "https:hachipoo.comdockside-app"

  livecheck do
    url "https:prajwalsd.github.ioDocksidereleasesappcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Dockside.app"

  zap trash: "~LibraryPreferencescom.hachipoo.Dockside.plist"
end