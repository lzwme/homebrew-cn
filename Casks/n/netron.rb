cask "netron" do
  version "8.3.0"
  sha256 "d9dc8b36d09a49b696ecde47a2d3b70343d50855f11a5d352798c08eeb056377"

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