cask "flowdown" do
  version "1.23.231"
  sha256 "c032f10d0d3df442d9ae16f1999d6234e293dd98154f44d4c18b5276e0e5c644"

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