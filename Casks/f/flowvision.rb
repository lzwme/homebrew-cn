cask "flowvision" do
  version "1.6.5"
  sha256 "54f2b72900a8d240ccc2486e1d61d8eac3af705c32d83e157407c8f9425d4039"

  url "https:github.comnetdcyFlowVisionreleasesdownload#{version}FlowVision.#{version}.zip",
      verified: "github.comnetdcyFlowVision"
  name "FlowVision"
  desc "Waterfall-style image viewer"
  homepage "https:flowvision.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :big_sur"

  app "FlowVision.app"

  zap trash: [
    "~LibraryApplication SupportFlowVision",
    "~LibraryPreferencesnetdcy.FlowVision.plist",
    "~LibrarySaved Application Statenetdcy.FlowVision.savedState",
  ]
end