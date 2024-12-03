cask "low-profile" do
  version "4.0.3"
  sha256 "9d27e90ddb3c2c35863cd31cfe58cedd2fda43aeb76cfa9fea02ca60132d4f5f"

  url "https:github.comninxsoftLowProfilereleasesdownloadv#{version}Low.Profile.#{version}.pkg"
  name "Low Profile"
  desc "Utility to help inspect Apple Configuration Profile payloads"
  homepage "https:github.comninxsoftLowProfile"

  depends_on macos: ">= :ventura"

  pkg "Low.Profile.#{version}.pkg"

  uninstall quit:    "com.ninxsoft.lowprofile",
            pkgutil: "com.ninxsoft.pkg.lowprofile"

  zap trash: [
    "~LibraryCachescom.ninxsoft.lowprofile",
    "~LibraryPreferencescom.ninxsoft.lowprofile.plist",
    "~LibrarySaved Application Statecom.ninxsoft.lowprofile.savedState",
  ]
end