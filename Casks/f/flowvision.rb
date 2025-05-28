cask "flowvision" do
  version "1.6.4"
  sha256 "90890929b097e598987b13370a2f9c29d37cc8efe206928136b48d93e6d9475b"

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