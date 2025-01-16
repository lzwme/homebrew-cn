cask "langgraph-studio" do
  version "0.0.35"
  sha256 "99566e0786d2f15e2cb70fcfe62b07596da7a81c9347361c7474669ca5dcde3b"

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