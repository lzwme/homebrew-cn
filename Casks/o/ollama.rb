cask "ollama" do
  version "0.5.5"
  sha256 "036c6f6b8af66b9a7ae62215772ab767c1957063cf8c86215c04a94f5b37ee5c"

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