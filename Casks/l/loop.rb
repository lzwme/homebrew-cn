cask "loop" do
  version "1.0.0"
  sha256 "d4343a3ba4240f4e3f99e4b45da4b4fafa6bfaf77971fc0649e855f1056062d2"

  url "https:github.comMrKai77Loopreleasesdownload#{version}Loop.zip"
  name "Loop"
  desc "Window manager"
  homepage "https:github.comMrKai77Loop"

  livecheck do
    url "https:mrkai77.github.ioLoopappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "Loop.app"

  uninstall quit: "com.MrKai77.Loop"

  zap trash: [
    "~LibraryApplication Scriptscom.MrKai77.Loop",
    "~LibraryApplication SupportLoop",
    "~LibraryCachescom.MrKai77.Loop",
    "~LibraryHTTPStoragescom.MrKai77.Loop",
    "~LibraryPreferencescom.MrKai77.Loop.plist",
  ]
end