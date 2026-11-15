cask "itsytv" do
  version "1.8.0"
  sha256 "f6731e3fa85769c7bb188f57da78ead4067f70cae95180c3575fb4c4ee150fc9"

  url "https://ghfast.top/https://github.com/nickustinov/itsytv-macos/releases/download/v#{version}/Itsytv-#{version}.dmg"
  name "Itsytv"
  desc "Menu bar app for controlling your Apple TV"
  homepage "https://itsytv.app/"

  depends_on macos: :sonoma

  app "Itsytv.app"

  zap trash: [
    "~/Library/Application Scripts/com.itsytv.app",
    "~/Library/Containers/com.itsytv.app",
  ]
end