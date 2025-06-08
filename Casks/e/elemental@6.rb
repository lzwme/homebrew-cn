cask "elemental@6" do
  version "6.5.0"
  sha256 "765b80d11bcdf6b558526ab9f7dc4811e0183917447b5c19a722da84ee969b54"

  url "https:github.comevolvedbinaryelementalreleasesdownloadelemental-#{version}elemental-#{version}.dmg",
      verified: "github.comevolvedbinaryelemental"
  name "elemental"
  desc "Native XML Database with XQuery and XSLT"
  homepage "https:www.elemental.xyz"

  livecheck do
    url :url
    regex(^elemental[._-]v?(6(?:\.\d+)+)$i)
  end

  app "Elemental.app"

  zap trash: "~LibraryApplication Supportxyz.elemental"

  caveats do
    depends_on_java "8"
  end
end