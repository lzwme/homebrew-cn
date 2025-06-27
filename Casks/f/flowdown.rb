cask "flowdown" do
  version "1.18.180"
  sha256 "4c5b75b1c2af0b63f390ee89e9e72131dec3b821e8db151e1cf9f4b62d4eedc3"

  url "https:github.comLakr233FlowDownreleasesdownload#{version}FlowDown-v#{version}.zip",
      verified: "github.comLakr233FlowDown"
  name "FlowDown"
  desc "AI agent"
  homepage "https:flowdown.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "FlowDown.app"

  zap trash: [
    "~LibraryContainerswiki.qaq.flow.FlowDownWidget",
    "~LibraryContainerswiki.qaq.FlowDown.Community",
  ]
end