cask "visual-studio-code" do
  arch arm: "darwin-arm64", intel: "darwin"

  on_catalina :or_older do
    version "1.97.2"
    sha256 arm:   "567ba4fae5545586a0bff02eea263d59873fcf488368a9a9ccf3d4c22dfa8ebc",
           intel: "cfe48cf7bce34830cb7a20ee7b5e8fbe575fe95a47ef49f62dce8ccf3087dd89"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "1.100.3"
    sha256 arm:   "29bfb6f688bf32cad86a3e708b322aeb694e9db9fac0d648f842c3e0c20818e7",
           intel: "ca93e09b462d6deb077ae9d2f74a09c8e15443d0524c25a17562d449c7d526f9"

    livecheck do
      url "https://update.code.visualstudio.com/api/update/#{arch}/stable/latest"
      strategy :json do |json|
        json["productVersion"]
      end
    end
  end

  url "https://update.code.visualstudio.com/#{version}/#{arch}/stable"
  name "Microsoft Visual Studio Code"
  name "VS Code"
  desc "Open-source code editor"
  homepage "https://code.visualstudio.com/"

  auto_updates true
  conflicts_with formula: "code-cli"
  depends_on macos: ">= :catalina"

  app "Visual Studio Code.app"
  binary "#{appdir}/Visual Studio Code.app/Contents/Resources/app/bin/code"

  uninstall launchctl: "com.microsoft.VSCode.ShipIt",
            quit:      "com.microsoft.VSCode"

  zap trash: [
    "~/.vscode",
    "~/Library/Application Support/Code",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.vscode.sfl*",
    "~/Library/Caches/com.microsoft.VSCode",
    "~/Library/Caches/com.microsoft.VSCode.ShipIt",
    "~/Library/HTTPStorages/com.microsoft.VSCode",
    "~/Library/Preferences/ByHost/com.microsoft.VSCode.ShipIt.*.plist",
    "~/Library/Preferences/com.microsoft.VSCode.helper.plist",
    "~/Library/Preferences/com.microsoft.VSCode.plist",
    "~/Library/Saved Application State/com.microsoft.VSCode.savedState",
  ]
end