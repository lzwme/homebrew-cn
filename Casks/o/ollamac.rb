cask "ollamac" do
  version "3.0.3"
  sha256 "f93012c37e5cc9858ea9eef06d74037b08080f9e23cf129504981d3de8305e9c"

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