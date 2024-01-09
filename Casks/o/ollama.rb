cask "ollama" do
  version "0.1.18"
  sha256 "8a8ad83a713b03453c4c3a2763f498149be27b191d481792ebb7b4c4c8dd876f"

  url "https:github.comjmorgancaollamareleasesdownloadv#{version}Ollama-darwin.zip",
      verified: "github.comjmorgancaollama"
  name "Ollama"
  desc "Get up and running with large language models locally"
  homepage "https:ollama.ai"

  auto_updates true
  conflicts_with formula: "ollama"
  depends_on macos: ">= :high_sierra"

  app "Ollama.app"
  binary "#{appdir}Ollama.appContentsResourcesollama"

  zap trash: [
    "~.ollama",
    "~LibraryApplication SupportOllama",
  ]
end