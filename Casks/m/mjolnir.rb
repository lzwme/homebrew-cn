cask "mjolnir" do
  version "1.0.2"
  sha256 "eb39b9ff76258c3aa7970f70465a7c858290ce798e5b8e411cb5b7d300de16d1"

  url "https:github.commjolnirappmjolnirreleasesdownload#{version}Mjolnir.app.zip",
      verified: "github.commjolnirappmjolnir"
  name "Mjolnir"
  desc "Lightweight automation and productivity app"
  homepage "https:mjolnir.rocks"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Mjolnir.app"

  zap trash: [
    "~.mjolnir",
    "~LibraryCachesorg.degutis.Mjolnir",
    "~LibraryPreferencesorg.degutis.Mjolnir.plist",
    "~LibrarySaved Application Stateorg.degutis.Mjolnir.savedState",
  ]

  caveats do
    requires_rosetta
  end
end