cask "flowdown" do
  version "1.26.262"
  sha256 "0e5bb68aa99d8e060d85718d3acc96cf325a9ad33483abe5d56f0d33767b16b8"

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