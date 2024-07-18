cask "keep" do
  version "1.2.0"
  sha256 "e5753208da6a1ae9a401e34389fa4cf71080647986981cbe389eed40ba86e9d5"

  url "https:github.comtmcinerneykeepreleasesdownloadv#{version}keep.v#{version}.zip"
  name "Keep"
  desc "Run Google Keep in the menu bar"
  homepage "https:github.comtmcinerneykeep"

  deprecate! date: "2024-07-17", because: :unmaintained

  app "Keep.app"

  uninstall signal: [
    ["TERM", "com.electron.keep"],
    ["TERM", "com.electron.keep.helper"],
  ]

  zap trash: [
    "~LibraryApplication SupportKeep",
    "~LibraryCachescom.electron.keep",
    "~LibraryPreferencescom.electron.keep.helper.plist",
    "~LibraryPreferencescom.electron.keep.plist",
    "~LibrarySaved Application Statecom.electron.keep.savedState",
  ]

  caveats do
    requires_rosetta
  end
end

# Last update in 2018