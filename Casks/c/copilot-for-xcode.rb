cask "copilot-for-xcode" do
  version "0.29.1"
  sha256 "cd4cbf5897c29489a44037f5a98d7c0288ec8d238fafe53f5b40dd7c5ef4866d"

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