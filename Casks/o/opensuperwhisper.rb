cask "opensuperwhisper" do
  version "0.0.4"
  sha256 "89bab368daf97ea9d4710f82d7be781c4d44651f0bc959e4c3cb2691311d7e2c"

  url "https:github.comstarmelOpenSuperWhisperreleasesdownload#{version}OpenSuperWhisper.dmg"
  name "OpenSuperWhisper"
  desc "Whisper dictationtranscription app"
  homepage "https:github.comstarmelOpenSuperWhisper"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sonoma"
  depends_on arch: :arm64

  app "OpenSuperWhisper.app"

  zap trash: [
    "~LibraryApplication Scriptsru.starmel.OpenSuperWhisper",
    "~LibraryApplication Supportru.starmel.OpenSuperWhisper",
  ]
end