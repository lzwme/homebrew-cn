cask "maccy" do
  version "2.0.1"
  sha256 "aa33acc30519a46b23f5a1edda9590dd3f66c8f7019832c837087987be22ecc5"

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