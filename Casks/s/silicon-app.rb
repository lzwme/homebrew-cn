cask "silicon-app" do
  version "1.0.5"
  sha256 "f8f6acfdc8378bca0429d52e34d48275c22213617dbe09055798132921c10586"

  url "https:github.comDigiDNASiliconreleasesdownload#{version}Silicon.app.zip"
  name "Silicon"
  desc "Identify Intel-only apps"
  homepage "https:github.comDigiDNASilicon"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Silicon.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.digidna.silicon.sfl*",
    "~LibraryCachescom.DigiDNA.Silicon",
    "~LibrarySaved Application Statecom.DigiDNA.Silicon.savedState",
  ]
end