cask "ollama" do
  version "0.1.22"
  sha256 "0d94b718cae2729a0ef207eeb86092597f869e6873c842d26aafd1da7013c8a7"

  url "https:github.comjmorgancaollamareleasesdownloadv#{version}Ollama-darwin.zip",
      verified: "github.comjmorgancaollama"
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
  ]
end