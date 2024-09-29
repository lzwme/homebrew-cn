cask "netron" do
  version "7.9.2"
  sha256 "e0b591a606d58b2bc227e6b70fcce0d2207c08f85555bbd0030db8315453742a"

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