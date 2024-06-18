cask "copilot-for-xcode" do
  version "0.33.3"
  sha256 "4bfaf3f8d8cfe4a5698f902aaa23e8982f584166762eb1ad1e691290a630c67b"

  url "https:github.comintitniCopilotForXcodereleasesdownload#{version}Copilot.for.Xcode.app.zip"
  name "Copilot for Xcode"
  desc "Xcode extension for GitHub Copilot"
  homepage "https:github.comintitniCopilotForXcode"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Copilot for Xcode.app"

  zap trash: [
    "~LibraryApplication Scripts*com.intii.CopilotForXcode*",
    "~LibraryApplication Supportcom.intii.CopilotForXcode",
    "~LibraryContainerscom.intii.CopilotForXcode.EditorExtension",
    "~LibraryGroup Containers*group.com.intii.CopilotForXcode*",
    "~LibraryLaunchAgentscom.intii.CopilotForXcode.XPCService.plist",
    "~LibraryPreferences5YKZ4Y3DAW.group.com.intii.CopilotForXcode.plist",
  ]
end