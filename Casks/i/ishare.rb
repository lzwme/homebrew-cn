cask "ishare" do
  version "4.1.5"
  sha256 "7f8fcffa6f8da58376ff5a005fd01bb774bd156128680f04ac65588972e8f4aa"

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