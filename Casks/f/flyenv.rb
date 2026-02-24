cask "flyenv" do
  arch arm: "-arm64"

  version "4.13.2"
  sha256 arm:   "8a2c1f9bac99cc6aa0a884452fdf8456df4f388afa14ca81f1a8fb58b653b26f",
         intel: "853677831402e0aea1e507429848d025cd373749da86909d7f30081dc91a6d8e"

  url "https://ghfast.top/https://github.com/xpf0000/FlyEnv/releases/download/v#{version}/FlyEnv-#{version}#{arch}-mac.zip",
      verified: "github.com/xpf0000/FlyEnv/"
  name "FlyEnv"
  desc "PHP and Web development environment manager"
  homepage "https://www.macphpstudy.com/"

  livecheck do
    url "https://ghfast.top/https://raw.githubusercontent.com/xpf0000/FlyEnv/master/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "FlyEnv.app"

  zap trash: [
    "~/Library/Application Support/PhpWebStudy",
    "~/Library/Logs/PhpWebStudy",
    "~/Library/PhpWebStudy",
    "~/Library/Preferences/phpstudy.xpfme.com.plist",
  ]
end