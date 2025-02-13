cask "github-copilot-for-xcode" do
  version "0.31.0"
  sha256 "f29662f9411e2c69fa89a9d073ea05cbc680650039bb5fde14abfcac40270b19"

  url "https:github.comgithubCopilotForXcodereleasesdownload#{version}GitHubCopilotForXcode.dmg"
  name "GitHub Copilot for Xcode"
  desc "Xcode extension for GitHub Copilot"
  homepage "https:github.comgithubCopilotForXcode"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "GitHub Copilot for Xcode.app"

  zap trash: [
    "~LibraryApplication Scriptscom.github.CopilotForXcode.EditorExtension",
    "~LibraryApplication ScriptsVEKTX9H2N7.group.com.github.CopilotForXcode",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.github.copilotforxcode.extensionservice.sfl*",
    "~LibraryApplication Supportcom.github.CopilotForXcode",
    "~LibraryContainerscom.github.CopilotForXcode.EditorExtension",
    "~LibraryGroup ContainersVEKTX9H2N7.group.com.github.CopilotForXcode",
    "~LibraryHTTPStoragescom.github.CopilotForXcode",
    "~LibraryLogsGitHubCopilot",
    "~LibraryPreferencescom.github.CopilotForXcode.plist",
    "~LibraryPreferencesVEKTX9H2N7.group.com.github.CopilotForXcode.prefs.plist",
  ]
end