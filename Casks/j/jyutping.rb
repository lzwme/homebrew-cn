cask "jyutping" do
  version "0.39.0"
  sha256 "240025d478654f7819a350b4b63dc6a5450fc6270e288e83bbcc21a8c456d717"

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