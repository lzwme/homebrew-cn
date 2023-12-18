cask "llamachat" do
  version "1.2.0"
  sha256 "dd423584428f4e80a4c2bb093bde132fc25699902c0b496037b3a951abb3348d"

  url "https:github.comalexrozanskiLlamaChatreleasesdownload#{version}LlamaChat.dmg",
      verified: "github.comalexrozanskiLlamaChat"
  name "LlamaChat"
  desc "Client for LLaMA models"
  homepage "https:llamachat.app"

  auto_updates true

  app "LlamaChat.app"

  zap trash: [
    "~LibraryApplication Supportcom.alexrozanski.LlamaChat",
    "~LibraryHTTPStoragescom.alexrozanski.LlamaChat",
    "~LibraryPreferencescom.alexrozanski.LlamaChat.plist",
  ]
end