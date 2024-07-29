cask "loop" do
  version "1.1.1"
  sha256 "785f01e2b9a4c93b53d2f59372375a35a5821d64a53df4b8b95576f4bfb05e23"

  url "https:github.comMrKai77Loopreleasesdownload#{version}Loop.zip"
  name "Loop"
  desc "Window manager"
  homepage "https:github.comMrKai77Loop"

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