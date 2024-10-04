cask "maccy" do
  version "2.1.0"
  sha256 "c8596ad80e4d02bc81536527564d55b92ecc06ca2ffc59b5e55c245fe3932c13"

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