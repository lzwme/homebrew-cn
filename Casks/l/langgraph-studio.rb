cask "langgraph-studio" do
  version "0.0.36"
  sha256 "62589c3c3d92dfd9efe10ba557c35df2ab9a67b2d6f992a414c18f917e51abcd"

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