cask "ollama" do
  version "0.1.40"
  sha256 "2b06ccc72a1133273a5678da716ceb37e179dde751cc1819d82177467f41b413"

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
  ]
end