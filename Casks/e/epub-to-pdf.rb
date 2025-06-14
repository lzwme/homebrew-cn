cask "epub-to-pdf" do
  version "3.1"
  sha256 "dcfc59d57f756802e844614b7dae43bca67284ec85fe6b909f244e41f20987b3"

  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/epub-2-pdf/e2p-#{version.major}.dmg",
      verified: "googleapis.com/google-code-archive-downloads/v2/code.google.com/epub-2-pdf/"
  name "epub-2-pdf"
  homepage "https://code.google.com/archive/p/epub-2-pdf"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "epub-to-pdf.app"
end