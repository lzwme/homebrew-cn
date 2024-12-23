cask "dockside" do
  version "1.9.19"
  sha256 "76324655e980c36a22a577a08b6fde2e4077ab6870c0d39e417d9a394537ea64"

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