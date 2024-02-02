cask "low-profile" do
  version "4.0.2"
  sha256 "185885cadd98405c7ba4c6b4e7342a4ea629bf3a27dd0684f01d5fce3c8e4fe6"

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