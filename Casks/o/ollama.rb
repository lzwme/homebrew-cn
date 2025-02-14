cask "ollama" do
  version "0.5.9"
  sha256 "52ebcc73b40d17f0a9b60c61601acbe85cb9f0b1869c000f1f7f262bb6467d23"

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