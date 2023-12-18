cask "bluetility" do
  version "1.5.1"
  sha256 "05ab67bf4ea75d7c6f533f8396b1f532978be1fe643523c31fa22a77f52215bc"

  url "https:github.comjnrossBluetilityreleasesdownload#{version}Bluetility.app.zip"
  name "Bluetility"
  desc "Bluetooth Low Energy browser"
  homepage "https:github.comjnrossBluetility"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Bluetility.app"

  zap trash: [
    "~LibraryPreferencescom.rossible.Bluetility.plist",
    "~LibrarySaved Application Statecom.rossible.Bluetility.savedState",
  ]
end