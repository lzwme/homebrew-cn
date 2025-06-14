cask "bindiff" do
  version "8"
  sha256 "2962fd337529a59fe4ba3b4a5596be53bfacd1bd0a3952ea7bedd6276eeb4db8"

  url "https:github.comgooglebindiffreleasesdownloadv#{version}BinDiff#{version}.dmg",
      verified: "github.comgooglebindiff"
  name "BinDiff"
  desc "Binary diffing tool"
  homepage "https:zynamics.combindiff.html"

  no_autobump! because: :requires_manual_review

  pkg "Install BinDiff.pkg"

  uninstall pkgutil: "com.google.security.zynamics.bindiff"

  zap trash: [
    "LibraryApplication SupportBinDiff",
    "~LibraryPreferencescom.google.security.zynamics.bindiff.plist",
    "~LibrarySaved Application Statecom.google.security.zynamics.bindiff.savedState",
  ]
end