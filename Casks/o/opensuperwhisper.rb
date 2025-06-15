cask "opensuperwhisper" do
  version "0.0.3"
  sha256 "01de2b8ba57360916457a926a2a13ec486f33080b6347d635c4da0721c20a2e4"

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