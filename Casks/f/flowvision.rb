cask "flowvision" do
  version "1.5.0"
  sha256 "7fa1ee5c71cf33ec4b0e77762cd56ee4e22fd6932c8c5d96745a178106bb56cf"

  url "https:github.comnetdcyFlowVisionreleasesdownload#{version}FlowVision.#{version}.zip"
  name "FlowVision"
  desc "Waterfall-style image viewer"
  homepage "https:github.comnetdcyFlowVision"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "FlowVision.app"

  zap trash: [
    "~LibraryApplication SupportFlowVision",
    "~LibraryPreferencesnetdcy.FlowVision.plist",
    "~LibrarySaved Application Statenetdcy.FlowVision.savedState",
  ]
end