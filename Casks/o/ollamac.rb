cask "ollamac" do
  version "2.1.2"
  sha256 "9072d9a172204f333853faebe16b4e9393a026f244d02397f54d249062b0dfac"

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