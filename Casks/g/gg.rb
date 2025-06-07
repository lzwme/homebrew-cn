cask "gg" do
  version "0.27.0"
  sha256 "56a9973d612c513548bb20ad7ecfb9f7991199139823b0c661f944f55d5873d4"

  url "https:github.comgulbananaggreleasesdownloadv#{version}gg_#{version}_universal.dmg"
  name "GG"
  desc "GUI for Jujutsu"
  homepage "https:github.comgulbananagg"

  depends_on macos: ">= :high_sierra"

  app "gg.app"

  zap trash: [
    "~LibraryApplication Supportau.gulbanana.gg",
    "~LibraryCachesau.gulbanana.gg",
    "~LibraryLogsau.gulbanana.gg",
    "~LibraryPreferencesau.gulbanana.gg.plist",
    "~LibraryWebKitau.gulbanana.gg",
  ]
end