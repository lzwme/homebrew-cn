cask "copilot-for-xcode" do
  version "0.33.4"
  sha256 "2c7ffb12d87a6d9e2c3c58abc843682a72547ecdd6f536a5f4db5bf9ee79f9b2"

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