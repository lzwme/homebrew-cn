cask "ollama" do
  version "0.6.6"
  sha256 "425ef28ce06c098172a071e49f8e8f23ceca1c1ea490167316c9c776f666cf17"

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