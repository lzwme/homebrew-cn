cask "motrix@beta" do
  arch arm: "-arm64", intel: on_system_conditional(macos: "-x64", linux: "-x86_64")
  os macos: "dmg", linux: "AppImage"

  version "2.0.0-beta.33"
  sha256 arm:          "42d35d728c3fc3ce39c09b0edde13e31acef6919c617ed1b33ca6e4cd568b39f",
         intel:        "3cbb0221215fe2d835b4dfc9668f1e833fcf46bae66562307e0ff2ee6cc13982",
         arm64_linux:  "452f026a3acb6c4af060ee8d26b29ab5d8601a1bebec2ce938005632de7bfb53",
         x86_64_linux: "927aa1ca5938dfc7a721adc5060557ff063212ed1bf7fc123ae3d8f54a571f6f"

  on_macos do
    depends_on macos: :ventura

    app "Motrix.app"

    zap trash: [
      "~/Library/Application Support/Motrix",
      "~/Library/Caches/app.motrix.native",
      "~/Library/Logs/Motrix",
      "~/Library/Preferences/app.motrix.native.plist",
      "~/Library/Saved Application State/app.motrix.native.savedState",
    ]
  end
  on_linux do
    app_image "Motrix-#{version}#{arch}.AppImage", target: "Motrix.AppImage"
  end

  url "https://ghfast.top/https://github.com/agalwood/Motrix/releases/download/v#{version}/Motrix-#{version}#{arch}.#{os}"
  name "Motrix Beta"
  desc "Open-source download manager"
  homepage "https://motrix.app/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || !release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true
  conflicts_with cask: "motrix"
end