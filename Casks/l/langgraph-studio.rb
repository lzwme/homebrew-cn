cask "langgraph-studio" do
  version "0.0.34"
  sha256 "33ea74137ebac7cfbf8caedd70a9c80d1e7b214d8938524ec8314eb92e4883f4"

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