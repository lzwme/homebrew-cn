cask "anarlog" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"
  url_end = on_system_conditional macos: "dmg", linux: "AppImage"

  version "1.4.21"
  sha256 arm:          "6f7d43547c05c64a0131d701146daf6f7f15aa76c376387b5cfede8ee5417d38",
         intel:        "f4d9927a51a8cc3c4029a657f20e74fff65fbaa1aa796068c6a9f2aad730a5dd",
         arm64_linux:  "aca5f5692354ea2a1269eb4a0ccbdbeb21462f95c493d46133eef2d4bb723c5c",
         x86_64_linux: "5106fb12a027f272805c98929251ffedf1f303a44e3b92affcd5877cf1d4442e"

  on_macos do
    auto_updates true
    depends_on macos: :sequoia

    app "Anarlog.app"

    zap trash: [
      "~/.local/bin/.anarlog-cli",
      "~/.local/bin/anarlog",
      "~/Library/Application Support/anarlog",
      "~/Library/Application Support/com.hyprnote.stable",
      "~/Library/Caches/com.hyprnote.stable",
      "~/Library/HTTPStorages/com.hyprnote.stable",
      "~/Library/Logs/com.hyprnote.stable",
      "~/Library/Preferences/com.hyprnote.stable.plist",
      "~/Library/Saved Application State/com.hyprnote.stable.savedState",
      "~/Library/WebKit/com.hyprnote.stable",
    ]
  end
  on_linux do
    app_image "anarlog-linux-#{arch}.AppImage", target: "Anarlog.AppImage"
  end

  url "https://ghfast.top/https://github.com/fastrepl/anarlog/releases/download/desktop_v#{version}/anarlog-#{os}-#{arch}.#{url_end}"
  name "Anarlog"
  desc "AI notepad for meetings"
  homepage "https://anarlog.so/"

  livecheck do
    url :url
    regex(/^desktop[._-]v?(\d+(?:\.\d+)+)$/i)
  end
end