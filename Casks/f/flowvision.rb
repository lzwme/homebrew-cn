cask "flowvision" do
  version "1.6.0"
  sha256 "429d1f970ae1025524faf9aaa961247c16673bda536a818bf39f83c8d2660021"

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