cask "maccy" do
  version "2.3.0"
  sha256 "3ebaf4b773af3d6527510ddc4c4dc3fa38f501228a983bc66489ca953d56b09d"

  url "https:github.comp0dejeMaccyreleasesdownload#{version}Maccy.app.zip",
      verified: "github.comp0dejeMaccy"
  name "Maccy"
  desc "Clipboard manager"
  homepage "https:maccy.app"

  livecheck do
    url "https:raw.githubusercontent.comp0dejeMaccymasterappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Maccy.app"

  uninstall quit: "org.p0deje.Maccy"

  zap login_item: "Maccy",
      trash:      [
        "~LibraryApplication Scriptsorg.p0deje.Maccy",
        "~LibraryContainersorg.p0deje.Maccy",
        "~LibraryPreferencesorg.p0deje.Maccy.plist",
      ]
end