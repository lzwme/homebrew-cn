cask "flyenv" do
  arch arm: "-arm64"

  version "4.9.4"
  sha256 arm:   "42f62d7a6256cfc590b32ff83cc134750d623e0c21a20c3e08eb2b6d43def6c3",
         intel: "4479ceafd639f263e4b7d8f58ee2caa6305c3dc70dfc57e9a16b9d876cd97cb7"

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