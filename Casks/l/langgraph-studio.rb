cask "langgraph-studio" do
  version "0.0.37"
  sha256 "3686a8164d001f371bfbd019024cbef0f2a8945e8fdca7467836cd5fc8882959"

  url "https:github.comlangchain-ailanggraph-studioreleasesdownloadv#{version}LangGraph-Studio-#{version}-universal.dmg",
      verified: "github.comlangchain-ailanggraph-studio"
  name "LangGraph Studio"
  desc "Desktop app for prototyping and debugging LangGraph applications locally"
  homepage "https:studio.langchain.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "LangGraph Studio.app"

  zap trash: [
    "~LibraryApplication SupportLangGraph Studio",
    "~LibraryPreferencescom.electron.langgraph-studio-desktop.plist",
    "~LibrarySaved Application Statecom.electron.langgraph-studio-desktop.savedState",
  ]
end