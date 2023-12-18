cask "low-profile" do
  version "4.0.1"
  sha256 "09ca984a85e16a6a188d7fc396578f8768fe0c7f8013a2e438ff52ce45388a39"

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