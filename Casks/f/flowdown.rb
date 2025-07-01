cask "flowdown" do
  version "1.24.242"
  sha256 "5b91d352a04ab8b8d8cf2c431248ed3c9ba5309b315be2a5b81c15e8916d5726"

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