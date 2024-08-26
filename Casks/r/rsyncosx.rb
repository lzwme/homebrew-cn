cask "rsyncosx" do
  version "6.8.0"
  sha256 "18ea590825ec6901b3df1cde7209cbaec8faa287a00539ad299af1f0ec9f41b7"

  url "https:github.comrsyncOSXRsyncOSX_archivedreleasesdownloadv#{version}RsyncOSX.#{version}.dmg"
  name "RsyncOSX"
  desc "GUI for rsync"
  homepage "https:github.comrsyncOSXRsyncOSX_archived"

  deprecate! date: "2024-08-25", because: :discontinued

  depends_on macos: ">= :big_sur"

  app "RsyncOSX.app"

  zap trash: [
    "~LibraryCachesno.blogspot.RsyncOSX",
    "~LibraryPreferencesno.blogspot.RsyncOSX.plist",
    "~LibrarySaved Application Stateno.blogspot.RsyncOSX.savedState",
  ]
end