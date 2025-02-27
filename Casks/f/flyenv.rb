cask "flyenv" do
  arch arm: "-arm64"

  version "4.8.6"
  sha256 arm:   "2e92b73c77159382fa19398c232e8cfeb9934480225ce3253147745ab8f86eb1",
         intel: "4f71260e1dfc9fbc67beaab38c8108f5f6924ef995263348e0a3456d2a07c2d4"

  url "https:github.comxpf0000FlyEnvreleasesdownloadv#{version}FlyEnv-#{version}#{arch}-mac.zip",
      verified: "github.comxpf0000FlyEnv"
  name "FlyEnv"
  desc "PHP and Web development environment manager"
  homepage "https:www.macphpstudy.com"

  livecheck do
    url "https:raw.githubusercontent.comxpf0000FlyEnvmasterlatest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "FlyEnv.app"

  zap trash: [
    "~LibraryApplication SupportPhpWebStudy",
    "~LibraryLogsPhpWebStudy",
    "~LibraryPhpWebStudy",
    "~LibraryPreferencesphpstudy.xpfme.com.plist",
  ]
end