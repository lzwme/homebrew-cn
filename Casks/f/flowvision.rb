cask "flowvision" do
  version "1.5.2"
  sha256 "e08383682f96a69a298cd944d6469b6de9d5ea6af66e133431557c2cc453c153"

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