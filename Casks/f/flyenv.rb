cask "flyenv" do
  arch arm: "-arm64"

  version "4.9.10"
  sha256 arm:   "82f60783e38d41eadd7ed79a02b01c3a1f08ea5c115423766d350a6755f33315",
         intel: "d6bea1ab20b9f3ce603976de343114277007c685f0faa642044eead945c70ab4"

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