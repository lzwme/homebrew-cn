cask "flyenv" do
  arch arm: "-arm64"

  version "4.9.7"
  sha256 arm:   "0c14164f3c7d32a4dea6ffcb87a4638538cffa9f822bc91247789dbe6e76b3cb",
         intel: "2fb647aea082a0c909de1528280279421467aa9b006608d69e8fb00cc09bcdcd"

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