cask "ollamac" do
  version "1.2.0"
  sha256 "118d3567a7e26f2e44b74a62c6158876e91bd068864b7f1fabd74d114b7f1846"

  url "https:github.comkevinhermawanOllamacreleasesdownloadv#{version}Ollamac-#{version}.dmg"
  name "Ollamac"
  desc "Interact with Ollama models"
  homepage "https:github.comkevinhermawanOllamac"

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Ollamac.app"

  zap trash: [
    "~LibraryApplication Scriptscom.kevinhermawa.Ollamac",
    "~LibraryContainerscom.kevinhermawan.Ollamac",
  ]
end