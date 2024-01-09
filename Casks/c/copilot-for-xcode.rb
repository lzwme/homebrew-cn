cask "copilot-for-xcode" do
  version "0.28.3"
  sha256 "19801de1f821f68a6b0f00593605b635431fee22b29b53a062cdf03a65256718"

  url "https:github.comintitniCopilotForXcodereleasesdownload#{version}Copilot.for.Xcode.app.zip"
  name "Copilot for Xcode"
  desc "Xcode extension for Github Copilot"
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