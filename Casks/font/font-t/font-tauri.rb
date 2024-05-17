cask "font-tauri" do
  version :latest
  sha256 :no_check

  url "https:github.comgooglefontsrawmainofltauriTauri-Regular.ttf",
      verified: "github.comgooglefonts"
  name "Tauri"
  homepage "https:fonts.google.comspecimenTauri"

  font "Tauri-Regular.ttf"

  # No zap stanza required
end