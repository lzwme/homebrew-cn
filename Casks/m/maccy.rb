cask "maccy" do
  version "0.29.2"
  sha256 "10d013f8955e4d7f57f4f25fdf25ed291fee5ab88b356cf9ac423a4dc2373e4b"

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
  depends_on macos: ">= :mojave"

  app "Maccy.app"

  uninstall quit: "org.p0deje.Maccy"

  zap login_item: "Maccy",
      trash:      [
        "~LibraryApplication Scriptsorg.p0deje.Maccy",
        "~LibraryContainersorg.p0deje.Maccy",
        "~LibraryPreferencesorg.p0deje.Maccy.plist",
      ]
end