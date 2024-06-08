cask "linear" do
  version "1.5"
  sha256 "a449b498e552fcc9de0f42a360f894d26e1796ce44ab1dc150fc87acab10a9c2"

  url "https:github.commikaa123linearreleasesdownload#{version}linear.zip",
      verified: "github.commikaa123linear"
  name "Linear"
  desc "Ruler app with web-development in mind"
  homepage "https:linear.theuxshop.com"

  disable! date: "2024-06-07", because: :unmaintained

  app "linear.app"

  zap trash: [
    "~.linear",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.linear.sfl*",
    "~LibraryApplication Supportlinear",
    "~LibraryCacheslinear",
    "~LibraryPreferencescom.electron.linear.plist",
    "~LibrarySaved Application Statecom.electron.linear.savedState",
  ]
end