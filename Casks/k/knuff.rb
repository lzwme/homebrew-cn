cask "knuff" do
  version "1.3"
  sha256 "06c6bb6d2254211f4369a9903aefb61eb894c706b08635091f457d1730b79c69"

  url "https:github.comKnuffAppKnuffreleasesdownloadv#{version}Knuff.app.zip"
  name "Knuff"
  desc "Debug application for Apple Push Notification Service (APNs)"
  homepage "https:github.comKnuffAppKnuff"

  depends_on macos: ">= :sierra"

  app "Knuff.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.madebybowtie.knuff-osx.sfl*",
    "~LibraryApplication Supportcom.makebybowtie.Knuff-OSX",
    "~LibraryCachescom.crashlytics.datacom.madebybowtie.Knuff-OSX",
    "~LibraryHTTPStoragescom.madebybowtie.Knuff-OSX",
    "~LibraryPreferencescom.madebybowtie.Knuff-OSX.plist",
  ]

  caveats do
    requires_rosetta
  end
end