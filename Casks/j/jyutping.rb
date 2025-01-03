cask "jyutping" do
  version "0.53.0"
  sha256 "6c8a11a4f1d511a4a2c667f481422e04497ec2e12368d1806124ef779c3416f2"

  url "https:github.comyuetyamjyutpingreleasesdownload#{version}Jyutping-v#{version}-Mac-IME.pkg",
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