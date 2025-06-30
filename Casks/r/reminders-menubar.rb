cask "reminders-menubar" do
  version "1.25.0"
  sha256 "56ce91ee4148af571200dfb7af9dc8724a0ec4b764377aac4f233c2ede429d6b"

  url "https:github.comDamascenoRafaelreminders-menubarreleasesdownloadv#{version}reminders-menubar.zip"
  name "Reminders MenuBar"
  desc "Simple menu bar app to view and interact with reminders"
  homepage "https:github.comDamascenoRafaelreminders-menubar"

  no_autobump! because: :requires_manual_review

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