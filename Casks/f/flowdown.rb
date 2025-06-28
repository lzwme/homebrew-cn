cask "flowdown" do
  version "1.19.190"
  sha256 "3e63ea30ba0128cefc790e953d903ad2e83e54e8d008f59bc73855c6b6caf012"

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