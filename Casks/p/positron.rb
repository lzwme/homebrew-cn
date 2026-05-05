cask "positron" do
  arch arm: "arm64", intel: "x64"

  version "2026.05.0-179"
  sha256 arm:   "4a51035ced7df0013b5d9db4b4255ea9bac250ad379796159fbef5b285e26649",
         intel: "77c405f7bb71a6681e5745071d6f46666d41bc95120eb6cb2474a80536b386a2"

  url "https://cdn.posit.co/positron/releases/mac/#{arch}/Positron-darwin-#{version}-#{arch}.zip"
  name "Positron"
  desc "Data science IDE"
  homepage "https://positron.posit.co/"

  livecheck do
    url "https://cdn.posit.co/positron/releases/mac/#{arch}/releases.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: ">= :monterey"

  app "Positron.app"

  zap trash: [
    "~/.positron",
    "~/Library/Application Support/Positron",
    "~/Library/Preferences/com.rstudio.positron.plist",
    "~/Library/Saved Application State/com.rstudio.positron.savedState",
  ]
end