cask "ollama" do
  version "0.1.19"
  sha256 "f6da387d45695ec93db00a52f6e001e702c28d17c71930d1bed98137b13c08da"

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