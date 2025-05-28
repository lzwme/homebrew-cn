cask "flyenv" do
  arch arm: "-arm64"

  version "4.9.12"
  sha256 arm:   "d5218925909546725ff394cc0546c3553dbfc5b1542ab46cb51882797502471c",
         intel: "4e802b0e5b10ba65e6fb2fc1cb2fcb71174973c8f178e0a769871e6feb7c1a1f"

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