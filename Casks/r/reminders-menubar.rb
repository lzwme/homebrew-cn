cask "reminders-menubar" do
  version "1.24.1"
  sha256 "ee2319d036fa1ebf0d904c9ffac3567a757f20f57d1ee4b156a196cc94aa1f63"

  url "https:github.comDamascenoRafaelreminders-menubarreleasesdownloadv#{version}reminders-menubar.zip"
  name "Reminders MenuBar"
  desc "Simple menu bar app to view and interact with reminders"
  homepage "https:github.comDamascenoRafaelreminders-menubar"

  depends_on macos: ">= :big_sur"

  app "Reminders MenuBar.app"

  uninstall quit: "br.com.damascenorafael.reminders-menubar"

  zap trash: [
    "~LibraryApplication Scriptsbr.com.damascenorafael.reminders-menubar",
    "~LibraryApplication Scriptsbr.com.damascenorafael.reminders-menubar-launcher",
    "~LibraryApplication Scriptsbr.com.damascenorafael.RemindersLauncher",
    "~LibraryContainersbr.com.damascenorafael.reminders-menubar",
    "~LibraryContainersbr.com.damascenorafael.reminders-menubar-launcher",
    "~LibraryContainersbr.com.damascenorafael.RemindersLauncher",
  ]
end