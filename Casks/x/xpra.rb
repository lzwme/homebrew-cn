cask "xpra" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "6.1.2,0"
    sha256 "45b47c4f374cad40c248bdc534b6b23c469bf1832ff8dedfdcaa0a1ec49c4d37"
  end
  on_intel do
    version "6.1.2,0"
    sha256 "b27859d3c48096443c3db96fd99ef5834b4516abe458c1be7d8614299211a1d5"
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