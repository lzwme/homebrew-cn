cask "langgraph-studio" do
  version "0.0.33"
  sha256 "424286f2713f6f3ed6fb3622723e944b8179d718c7e6edddbc033d634975141e"

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