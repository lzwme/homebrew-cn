cask "xpra" do
  arch arm: "arm64", intel: "x86_64"

  on_arm do
    version "6.2.3,0"
    sha256 "762c4e40987193096b187e546b9e02e1cc3891af6e09bc14e1170c64c888b53d"
  end
  on_intel do
    version "6.2.5,0"
    sha256 "0081002f2a867a2d5cf41a81d4b04b9bbc888d455c65b98cb1c3142e7bae7b78"
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
end