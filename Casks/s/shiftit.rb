cask "shiftit" do
  version "1.6.6"
  sha256 "858045662074579856a521dcf967ddfc818f68583ddc96fe73612d82e071bd00"

  url "https:github.comfikovnikShiftItreleasesdownloadversion-#{version}ShiftIt-#{version}.zip"
  name "ShiftIt"
  desc "Tool to manage the size and position of windows"
  homepage "https:github.comfikovnikShiftIt"

  deprecate! date: "2023-12-17", because: :discontinued

  auto_updates true

  app "ShiftIt.app"

  zap trash: [
    "~LibraryApplication SupportShiftIt",
    "~LibraryCachesorg.shiftitapp.ShiftIt",
    "~LibraryPreferencesorg.shiftitapp.ShiftIt.plist",
  ]
end