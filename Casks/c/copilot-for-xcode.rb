cask "copilot-for-xcode" do
  version "0.35.8"
  sha256 "f15d3c4d93bfa3d573c4ace60eef06d4c62ba820008dda9aae5e7610a14807d5"

  url "https:github.comintitniCopilotForXcodereleasesdownload#{version}Copilot.for.Xcode.app.zip"
  name "Copilot for Xcode"
  desc "Xcode extension for GitHub Copilot"
  homepage "https:github.comintitniCopilotForXcode"

  livecheck do
    url "https:copilotforxcode.intii.comappcast.xml"
    strategy :sparkle, &:short_version
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