cask "ishare" do
  version "4.2.1"
  sha256 "b55714ae1863f771c0ae4f2f58e2ec16e7a660ba1cf077aea65c76e9b102edce"

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