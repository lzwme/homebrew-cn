cask "pliim" do
  version "1.7.0"
  sha256 "cd44a3e8d0d58b431df288c3ce13a8032f76b270077ac488cb9db5d74e7d17a5"

  url "https://ghfast.top/https://github.com/zehfernandes/pliim/releases/download/v#{version}/Pliim.app.zip",
      verified: "github.com/zehfernandes/pliim/"
  name "Pliim"
  desc "One click and be ready to go up on stage and shine!"
  homepage "https://zehfernandes.github.io/pliim/"

  disable! date: "2026-09-01", because: :fails_gatekeeper_check

  app "Pliim.app"

  zap trash: [
    "~/Library/Application Support/Pliim",
    "~/Library/Logs/Pliim",
    "~/Library/Preferences/com.electron.pliim.plist",
    "~/Library/Saved Application State/com.electron.pliim.savedState",
  ]

  caveats do
    requires_rosetta
  end
end