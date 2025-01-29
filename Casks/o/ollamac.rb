cask "ollamac" do
  version "3.0.1"
  sha256 "8adce6354b3714d1e8954536b8782407b536c96846cc282d47debcfd3974719c"

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