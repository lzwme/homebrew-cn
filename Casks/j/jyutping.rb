cask "jyutping" do
  version "0.45.0"
  sha256 "b5f4dfd6bb683944cfc796a03da37f41eb1119b42f5a4192c53fe187b5ff3aef"

  url "https:github.comyuetyamjyutpingreleasesdownload#{version}Jyutping-v#{version}-Mac-IME.pkg.zip",
      verified: "github.comyuetyamjyutping"
  name "Jyutping"
  desc "Cantonese Jyutping Input Method"
  homepage "https:jyutping.app"

  livecheck do
    url "https:jyutping.appappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "Jyutping-v#{version}-Mac-IME.pkg"

  uninstall quit:    "org.jyutping.inputmethod.Jyutping",
            pkgutil: "org.jyutping.inputmethod.Jyutping",
            delete:  "LibraryInput MethodsJyutping.app"

  zap trash: [
    "~LibraryApplication Scriptsorg.jyutping.inputmethod.Jyutping",
    "~LibraryCachesorg.jyutping.inputmethod.Jyutping",
    "~LibraryContainersorg.jyutping.inputmethod.Jyutping",
  ]
end