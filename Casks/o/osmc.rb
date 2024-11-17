cask "osmc" do
  version :latest
  sha256 :no_check

  url "https:download.osmc.tvinstallersosmc-installer.dmg"
  name "OSMC"
  desc "Free and open source media center"
  homepage "https:osmc.tv"

  livecheck do
    skip "unversioned QT application"
  end

  # Renamed for clarity: app name is inconsistent with its branding.
  # Original discussion: https:github.comHomebrewhomebrew-caskpull9420
  app "qt_host_installer.app", target: "OSMC.app"

  zap trash: [
    "~LibrarySaved Application Statetv.osmc.installer.savedState",
    "~omsc_installer_log.txt",
  ]

  caveats do
    requires_rosetta
  end
end