cask "loop" do
  version "1.2.0"
  sha256 "3287c5b9ca7f194aae53b071e2078f216492ac0a8551fd2ae7d20cf0c80920fb"

  url "https:github.comMrKai77Loopreleasesdownload#{version}Loop.zip"
  name "Loop"
  desc "Window manager"
  homepage "https:github.comMrKai77Loop"

  no_autobump! because: :requires_manual_review

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