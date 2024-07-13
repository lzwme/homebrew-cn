cask "helium" do
  version "1.0.0"
  sha256 "30abcdcb04e53f24948897acfd24899c7cdfca564b71b023224ae13f11365bbd"

  url "https:github.comkoushCarbonResourcesreleasesdownloadv#{version}carbon-mac.zip"
  name "Helium"
  homepage "https:github.comkoushsupport-wikiwikiHelium-Desktop-Installer-and-Android-App"

  app "Helium.app"

  uninstall quit: "com.koushikdutta.Helium"

  zap trash: "~LibrarySaved Application Statecom.koushikdutta.Helium.savedState"

  caveats do
    requires_rosetta
  end
end