cask "tikzit" do
  version "2.1.6"
  sha256 "4c7e2de7f021805272505b5313890ec4bcd42e2a66c2de7af74a866e5c96a3ed"

  url "https://ghfast.top/https://github.com/tikzit/tikzit/releases/download/v#{version}/tikzit-osx.dmg",
      verified: "github.com/tikzit/tikzit/"
  name "TikZiT"
  desc "PGF/TikZ diagram editor"
  homepage "https://tikzit.github.io/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "TikZiT.app"

  zap trash: [
    "~/Library/Preferences/com.tikzit.tikzit.plist",
    "~/Library/Preferences/io.github.tikzit.plist",
    "~/Library/Saved Application State/io.github.tikzit.savedState",
  ]

  caveats do
    requires_rosetta
  end
end