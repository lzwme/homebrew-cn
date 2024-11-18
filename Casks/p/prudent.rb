cask "prudent" do
  version "29"
  sha256 "375970eadf59bab17e8add0057ea967b0376eb1385889d5b64f84a720e4dd4cb"

  url "https:github.comPrudentMemainreleasesdownload#{version}Prudent.zip",
      verified: "github.comPrudentMemain"
  name "Prudent"
  desc "Integrated environment for your personal and family ledger"
  homepage "https:prudent.me"

  app "Prudent.app"

  zap trash: [
    "~LibraryApplication SupportPrudent",
    "~LibraryCachesPruent",
    "~LibraryPreferencescom.runningroot.prudent.plist",
    "~LibrarySaved Application Statecom.runningroot.prudent.savedState",
  ]

  caveats do
    requires_rosetta
  end
end