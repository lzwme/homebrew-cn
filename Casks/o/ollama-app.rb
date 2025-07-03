cask "ollama-app" do
  version "0.9.5"
  sha256 "68bae8610d04ca9486284ab5679ffd5b1f2bdc3e5aeb2b1852da3141a3fa3838"

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