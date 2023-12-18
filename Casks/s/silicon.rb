cask "silicon" do
  version "1.0.5"
  sha256 "f8f6acfdc8378bca0429d52e34d48275c22213617dbe09055798132921c10586"

  url "https:github.comDigiDNASiliconreleasesdownload#{version}Silicon.app.zip"
  name "Silicon"
  desc "Identify Intel-only apps"
  homepage "https:github.comDigiDNASilicon"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Silicon.app"

  zap trash: [
    "~LibraryCachescom.DigiDNA.Silicon",
    "~LibrarySaved Application Statecom.DigiDNA.Silicon.savedState",
  ]
end