cask "eul" do
  version "1.6.2"
  sha256 "09b036f1e934472d55a0417e2a3ce736559caf81a38537c94ab2c6331f258851"

  url "https:github.comgao-suneulreleasesdownloadv#{version}eul.app.zip"
  name "eul"
  desc "Status monitoring"
  homepage "https:github.comgao-suneul"

  depends_on macos: ">= :catalina"

  app "eul.app"

  zap trash: [
    "~LibraryApplication Scriptscom.gaosun.eul.BatteryWidget",
    "~LibraryApplication Scriptscom.gaosun.eul.CpuWidget",
    "~LibraryApplication Scriptscom.gaosun.eul.MemoryWidget",
    "~LibraryApplication Scriptscom.gaosun.eul.NetworkWidget",
    "~LibraryApplication Scriptscom.gaosun.eul.shared",
    "~LibraryCachescom.gaosun.eul",
    "~LibraryContainerscom.gaosun.eul.BatteryWidget",
    "~LibraryContainerscom.gaosun.eul.CpuWidget",
    "~LibraryContainerscom.gaosun.eul.MemoryWidget",
    "~LibraryContainerscom.gaosun.eul.NetworkWidget",
    "~LibraryGroup Containerscom.gaosun.eul.shared",
    "~LibraryHTTPStoragescom.gaosun.eul",
    "~LibraryPreferencescom.gaosun.eul.plist",
  ]
end