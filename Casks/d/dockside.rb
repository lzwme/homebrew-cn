cask "dockside" do
  version "1.9.37"
  sha256 "9fc2f91155a791fd3f7283db73bde6562aa1e43e7dabd9443f4f29c061b720a3"

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