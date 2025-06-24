cask "katana-app" do
  version "1.4.4"
  sha256 "905a578cd5d2fd3ee18e521ef0e1574f19229938181585bee41008b172dc5d1e"

  url "https:github.combluegillkatanareleasesdownloadv#{version}katana-#{version}-mac.zip"
  name "Katana"
  desc "Open-source screenshot utility"
  homepage "https:github.combluegillkatana"

  no_autobump! because: :requires_manual_review

  app "Katana.app"

  zap trash: [
    "~.katana",
    "~LibraryApplication SupportKatana",
    "~LibraryLogsKatana",
    "~LibraryPreferencescom.electron.katana.plist",
  ]

  caveats do
    requires_rosetta
  end
end