cask "github-copilot-for-xcode" do
  version "0.33.0"
  sha256 "9c6f81d1abd9a28daf25d2574124747daedcf31eded658353f2bee1efbb29cf6"

  url "https:githubcopilotide.z13.web.core.windows.net#{version}GitHubCopilotForXcode.dmg",
      verified: "githubcopilotide.z13.web.core.windows.net"
  name "GitHub Copilot for Xcode"
  desc "Xcode extension for GitHub Copilot"
  homepage "https:github.comgithubCopilotForXcode"

  livecheck do
    url "https:githubcopilotide.z13.web.core.windows.netappcast.xml"
    strategy :sparkle do |items|
      items.find { |item| item.channel.nil? }&.short_version
    end
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