cask "ollamac" do
  version "2.0.0"
  sha256 "615f52db607f16c5c9501bbadb3da80ce5e39c8aa32696912fc37bcb9c9fcb9f"

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