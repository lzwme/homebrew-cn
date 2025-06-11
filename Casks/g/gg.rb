cask "gg" do
  version "0.29.0"
  sha256 "b97d4dd29884b8f09a5501151ba1ebde7b2874ffaf51b59ed674bc3d30c8c082"

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