cask "netron" do
  version "7.4.9"
  sha256 "5aa03627816773c018ad635bcbce5d6d5c683cd332a2009cea9314537f8ac66d"

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