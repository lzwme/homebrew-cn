cask "flowvision" do
  version "1.6.2"
  sha256 "c74e07d21927371a7ebcc5d7785416c1e9c3efe3d5c9b7e1fc99ba7b6631ce8a"

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