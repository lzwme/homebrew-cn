cask "elemental" do
  version "7.0.0"
  sha256 "fea71251b2b9859923a1ba4f9509c0f0b104b4265e8ba7fcb33828b110b399cf"

  url "https:github.comevolvedbinaryelementalreleasesdownloadelemental-#{version}elemental-#{version}.dmg",
      verified: "github.comevolvedbinaryelemental"
  name "elemental"
  desc "Native XML Database with XQuery and XSLT"
  homepage "https:www.elemental.xyz"

  app "Elemental.app"

  zap trash: "~LibraryApplication Supportxyz.elemental"

  caveats do
    depends_on_java "8"
  end
end