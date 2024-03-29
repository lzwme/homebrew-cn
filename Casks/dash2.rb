cask "dash2" do
  version "2.2.6"
  sha256 "a7de5e00528611f86d1024164b1b5d536ce039344b6ca3c211918c7458f7e412"

  url "https://kapeli.com/downloads/v#{version.major}/Dash.zip"
  name "Dash"
  desc "API documentation browser and code snippet manager"
  homepage "https://kapeli.com/dash"

  deprecate! date: "2023-12-17", because: :discontinued

  app "Dash.app"

  zap trash: [
    "~/Library/Application Support/Dash",
    "~/Library/Preferences/com.kapeli.dash.plist",
    "~/Library/Preferences/com.kapeli.dashdoc.plist",
  ]
end