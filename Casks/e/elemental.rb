cask "elemental" do
  version "7.1.0"
  sha256 "9164e57df978cdd7c1f3cd6cf1d707fd9298cc814b564185cd6e5763c793040c"

  url "https:github.comevolvedbinaryelementalreleasesdownloadelemental-#{version}elemental-#{version}.dmg",
      verified: "github.comevolvedbinaryelemental"
  name "elemental"
  desc "Native XML Database with XQuery and XSLT"
  homepage "https:www.elemental.xyz"

  livecheck do
    url :url
    regex(^elemental[._-]v?(\d+(?:\.\d+)+)$i)
  end

  app "Elemental.app"

  zap trash: "~LibraryApplication Supportxyz.elemental"

  caveats do
    depends_on_java "21"
  end
end