cask "langgraph-studio" do
  version "0.0.37"
  sha256 "3686a8164d001f371bfbd019024cbef0f2a8945e8fdca7467836cd5fc8882959"

  url "https://ghfast.top/https://github.com/langchain-ai/langgraph-studio/releases/download/v#{version}/LangGraph-Studio-#{version}-universal.dmg",
      verified: "github.com/langchain-ai/langgraph-studio/"
  name "LangGraph Studio"
  desc "Desktop app for prototyping and debugging LangGraph applications locally"
  homepage "https://studio.langchain.com/"

  deprecate! date: "2025-08-30", because: :discontinued

  app "LangGraph Studio.app"

  zap trash: [
    "~/Library/Application Support/LangGraph Studio",
    "~/Library/Preferences/com.electron.langgraph-studio-desktop.plist",
    "~/Library/Saved Application State/com.electron.langgraph-studio-desktop.savedState",
  ]
end