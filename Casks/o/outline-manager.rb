cask "outline-manager" do
  version "1.14.0"
  sha256 "148e8359c7351c072e63f613d21899485568b7dcc397fd7a80d9fc10d570baee"

  url "https:github.comJigsaw-Codeoutline-serverreleasesdownloadmanager-v#{version}Outline-Manager.dmg",
      verified: "github.comJigsaw-Codeoutline-server"
  name "Outline Manager"
  desc "Tool to create and manage Outline servers, powered by Shadowsocks"
  homepage "https:www.getoutline.org"

  # The GitHub repository contains tagreleases for other software and the
  # "latest" release may not be for Outline Manager, so we have to check
  # multiple releases to identify the latest version.
  livecheck do
    url :url
    regex(%r{^(?:manager(?:[._-]macos)?[._-])?v?(\d+(?:\.\d+)+)$}i)
    strategy :github_releases
  end

  app "Outline Manager.app"

  zap trash: [
    "~LibraryApplication SupportOutline Manager",
    "~LibraryPreferencescom.electron.outline-manager.plist",
    "~LibrarySaved Application Statecom.electron.outline-manager.savedState",
  ]
end