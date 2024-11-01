cask "geneious-prime" do
  version "2025.0.2"
  sha256 "f2a206a05419573c5c5b13dbebc6de98309fd43df27e456fe460a3ecb8e87ba2"

  url "https://assets.geneious.com/installers/geneious/release/Geneious_Prime_mac64_#{version.dots_to_underscores}_with_jre.dmg"
  name "Geneious Prime"
  desc "Bioinformatics software platform"
  homepage "https://www.geneious.com/"

  livecheck do
    url "https://www.geneious.com/updates"
    regex(/href=.*?Geneious[._-]Prime[._-]mac64[._-]v?(\d+(?:[._]\d+)+).*?\.dmg/i)
    strategy :page_match do |page, regex|
      page.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  app "Geneious Prime.app"

  zap trash: [
    "~/Geneious #{version.major}.0 Data",
    "~/Library/Application Support/Geneious",
    "~/Library/Preferences/com.biomatters.*.plist",
    "~/Library/Preferences/Geneious.in.use.vmoptions",
    "~/Library/Saved Application State/com.biomatters.Geneious.savedState",
  ]

  caveats do
    requires_rosetta
  end
end