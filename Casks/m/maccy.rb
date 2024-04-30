cask "maccy" do
  version "0.31.0"
  sha256 "be37c5b655f46f7868c147366d347fa6a5f09f38d7a4aeaa3d1f3ef35b00353b"

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