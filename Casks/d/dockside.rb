cask "dockside" do
  version "1.9.44"
  sha256 "bf6a23ee0f48397268490f33555b94d9b07d0605298201c395480b8dbdc988c8"

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