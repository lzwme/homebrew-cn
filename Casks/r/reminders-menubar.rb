cask "reminders-menubar" do
  version "1.21.0"
  sha256 "9c6a410732ea140f3ba360b81d54c070539960752d1f220bef50f1b5c14497dd"

  url "https:github.comDamascenoRafaelreminders-menubarreleasesdownloadv#{version}reminders-menubar.zip"
  name "Reminders MenuBar"
  desc "Simple menu bar app to view and interact with reminders"
  homepage "https:github.comDamascenoRafaelreminders-menubar"

  depends_on macos: ">= :big_sur"

  app "Reminders MenuBar.app"

  uninstall quit: "br.com.damascenorafael.reminders-menubar"

  zap trash: [
    "~LibraryApplication Scriptsbr.com.damascenorafael.reminders-menubar",
    "~LibraryApplication Scriptsbr.com.damascenorafael.RemindersLauncher",
    "~LibraryContainersbr.com.damascenorafael.reminders-menubar",
    "~LibraryContainersbr.com.damascenorafael.RemindersLauncher",
  ]
end