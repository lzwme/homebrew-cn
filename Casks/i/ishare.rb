cask "ishare" do
  version "4.1.0"
  sha256 "dca8b6a8b05fd2fb01d7fbaf0b5e0c946ce7a644d9b81a644256024b18b90ad8"

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