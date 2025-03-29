cask "netron" do
  version "8.2.4"
  sha256 "add51f5c8873735cf79b8602e1f0f17f7cef321883cb899d8957a414bdeddf6c"

  url "https:github.comlutzroedernetronreleasesdownloadv#{version}Netron-#{version}-mac.zip"
  name "Netron"
  desc "Visualiser for neural network, deep learning, and machine learning models"
  homepage "https:github.comlutzroedernetron"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Netron.app"

  zap trash: [
    "~LibraryApplication SupportNetron",
    "~LibraryPreferencescom.lutzroeder.netron.plist",
    "~LibrarySaved Application Statecom.lutzroeder.netron.savedState",
  ]
end