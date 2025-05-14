cask "flyenv" do
  arch arm: "-arm64"

  version "4.9.9"
  sha256 arm:   "13ec8dbfdbbbafea2b28f0dbd91801fbea5e41b568f5b948894eb466c8eedac1",
         intel: "e4a5b812b3acb14fab8f60bcd500e93c2516975b554e362f8887fae63ad17aa6"

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