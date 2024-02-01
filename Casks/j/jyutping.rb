cask "jyutping" do
  version "0.35.0"
  sha256 "7f820d1dd2b9c45c6c3965c993819755a6d70c0b65542d849512ee5783405842"

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