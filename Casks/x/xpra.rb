cask "xpra" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "6.1.3,0"
    sha256 "1f9af6aef560d532931fc299ed92341d3bdce5fc9fc7d9bd2013d43d7db29c2c"
  end
  on_intel do
    version "6.1.3,0"
    sha256 "eeb7905746b55e5ce2037248398042ae8670881dd24afd1badf01eb17b0e07c6"
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