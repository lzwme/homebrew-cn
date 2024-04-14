cask "netron" do
  version "7.6.0"
  sha256 "c0e202c7b733f738ba3fc10be9df298abdced6d0f5b32b0b571b9068801b5b01"

  url "https:github.comlutzroedernetronreleasesdownloadv#{version}Netron-#{version}-mac.zip"
  name "Netron"
  desc "Visualiser for neural network, deep learning, and machine learning models"
  homepage "https:github.comlutzroedernetron"

  auto_updates true

  app "Netron.app"

  zap trash: [
    "~LibraryApplication SupportNetron",
    "~LibraryPreferencescom.lutzroeder.netron.plist",
    "~LibrarySaved Application Statecom.lutzroeder.netron.savedState",
  ]
end