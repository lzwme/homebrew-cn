cask "reminders-menubar" do
  version "1.24.0"
  sha256 "79fc0099410414fec3c07818f9631b6c1f8651c74b6c42cb2c4393972608a5ce"

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