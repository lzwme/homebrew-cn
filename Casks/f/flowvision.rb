cask "flowvision" do
  version "1.6.3"
  sha256 "27ccb4531a7e5afe7fa7ced87422096986dd859bd7db88f7776a64f0f85802b2"

  url "https:github.comnetdcyFlowVisionreleasesdownload#{version}FlowVision.#{version}.zip",
      verified: "github.comnetdcyFlowVision"
  name "FlowVision"
  desc "Waterfall-style image viewer"
  homepage "https:flowvision.app"

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