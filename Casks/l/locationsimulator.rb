cask "locationsimulator" do
  version "0.2.2"
  sha256 "867941213a23e23c22a3e868e0fa5fec443d1e597e912eca8a1e97f68e7dbb08"

  url "https:github.comSchlaubischlumpLocationSimulatorreleasesdownloadv#{version}LocationSimulator.app.zip"
  name "LocationSimulator"
  desc "Application to spoof your iOS, iPadOS or iPhoneSimulator device location"
  homepage "https:github.comSchlaubischlumpLocationSimulator"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :catalina"

  app "LocationSimulator.app"

  zap trash: [
    "~LibraryApplication SupportLocationSimulator",
    "~LibraryPreferencescom.schlaubi.LocationSimulator.plist",
  ]
end