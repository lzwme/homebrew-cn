cask "ollama" do
  version "0.6.8"
  sha256 "ba86af4807838b61ca76223ba08eae843b86b152a15105597549c85af99f5947"

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