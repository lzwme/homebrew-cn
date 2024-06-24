cask "pppc-utility" do
  version "1.5.0"
  sha256 "208f066e176197424cbbf8dd0803e9407c800de621c322feb566d20b9f3be32c"

  url "https:github.comjamfPPPC-Utilityreleasesdownload#{version}PPPC-Utility.zip"
  name "PPPC Utility"
  name "Privacy Preferences Policy Control Utility"
  desc "Create configuration profiles containing a PPPC payload"
  homepage "https:github.comjamfPPPC-Utility"

  depends_on macos: ">= :catalina"

  app "PPPC Utility.app"

  uninstall quit: "com.jamf.opensource.pppcutility"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.jamf.opensource.pppcutility*",
    "~LibraryContainerscom.jamf.opensource.pppcutility",
  ]
end