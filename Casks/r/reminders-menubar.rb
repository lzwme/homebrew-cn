cask "reminders-menubar" do
  version "1.22.0"
  sha256 "7176c79253f530e665d1f471543352a9a9b05bd2b9b25aff3414e223e8e9c145"

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