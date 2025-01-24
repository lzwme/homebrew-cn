cask "flowvision" do
  version "1.4.0"
  sha256 "b42a7f0d6c32575a1e9b99744c4d4beb1c23c5ab19786a28df7bab3f6c85d3e5"

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