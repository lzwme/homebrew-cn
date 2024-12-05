cask "ishare" do
  version "4.1.4"
  sha256 "9ff91b06074ee32b6088083133044f79d7e8dd8587576f1410b917a798a02ca2"

  url "https:github.comcastdrianisharereleasesdownloadv#{version}ishare.dmg"
  name "ishare"
  desc "Screenshot capture utility"
  homepage "https:github.comcastdrianishare"

  livecheck do
    url :url
    regex(v?(\d+(?:\.\d+)+)i)
  end

  depends_on macos: ">= :sequoia"

  app "ishare.app"

  zap trash: [
    "~LibraryApplication Scriptsdev.adrian.ishare.sharemenuext",
    "~LibraryContainersdev.adrian.ishare.sharemenuext",
    "~LibraryPreferencesdev.adrian.ishare.plist",
  ]
end