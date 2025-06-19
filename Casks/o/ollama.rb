cask "ollama" do
  version "0.9.2"
  sha256 "c24a32be4a4405cd834ad1c6200155944d38d13227ea6f8ee98e2e1f1dec1460"

  url "https:github.comollamaollamareleasesdownloadv#{version}Ollama-darwin.zip",
      verified: "github.comollamaollama"
  name "Ollama"
  desc "Get up and running with large language models locally"
  homepage "https:ollama.ai"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  conflicts_with formula: "ollama"
  depends_on macos: ">= :high_sierra"

  app "Ollama.app"
  binary "#{appdir}Ollama.appContentsResourcesollama"

  zap trash: [
    "~.ollama",
    "~LibraryApplication SupportOllama",
    "~LibraryPreferencescom.electron.ollama.plist",
    "~LibrarySaved Application Statecom.electron.ollama.savedState",
  ]
end