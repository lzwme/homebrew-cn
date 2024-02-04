cask "ollama" do
  version "0.1.23"
  sha256 "b1f3343f657dab21410090c8dd5f41e301cf2dd8a9ead3e5d7dfeb0654f69fdd"

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