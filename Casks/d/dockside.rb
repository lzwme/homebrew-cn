cask "dockside" do
  version "1.5.9"
  sha256 "ae7a72401e04338be9cb95149e806a0d0bbed3d056577150ca1e724b9b7c7d6e"

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