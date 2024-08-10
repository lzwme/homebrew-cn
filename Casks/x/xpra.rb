cask "xpra" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "6.1.1,0"
    sha256 "560ea4dfa1ddee695ae21360dc063eb9207f03ba0d75956d7595bfab0cc7f404"
  end
  on_intel do
    version "6.1,0"
    sha256 "89d08abf9c42c28c15813e4638511303e78fd10bc940ee8d743195d570a1b7a4"
  end

  url "https:xpra.orgdistsMacOS#{arch}Xpra-#{arch}-#{version.csv.first}-r#{version.csv.second}.dmg",
      verified: "xpra.org"
  name "Xpra"
  desc "Screen and application forwarding system"
  homepage "https:github.comXpra-orgxpra"

  livecheck do
    url "https:xpra.orgdistsMacOS#{arch}"
    regex(href=.*?Xpra-#{arch}[._-]v?(\d+(?:\.\d+)+)(?:[._-]r(\d+))?\.dmgi)
    strategy :page_match do |page, regex|
      page.scan(regex).map do |match|
        match[1] ? "#{match[0]},#{match[1]}" : match[0]
      end
    end
  end

  depends_on macos: ">= :sierra"

  app "Xpra.app"

  zap delete: "LibraryApplication SupportXpra",
      trash:  [
        "~LibraryApplication SupportXpra",
        "~LibrarySaved Application Stateorg.xpra.xpra.savedState",
      ]

  caveats do
    requires_rosetta
  end
end