cask "opencore-legacy-patcher" do
  version "1.4.3"
  sha256 "391fccf00fa221a27bef8a03bbad2dcbb36f73d5521a7dd2d755c93280749c1c"

  url "https:github.comdortaniaOpenCore-Legacy-Patcherreleasesdownload#{version}OpenCore-Patcher-GUI.app.zip",
      verified: "github.comdortaniaOpenCore-Legacy-Patcher"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur, Monterey and Ventura (11.x-13.x) on unsupported Macs"
  homepage "https:dortania.github.ioOpenCore-Legacy-Patcher"

  app "OpenCore-Patcher.app", target: "LibraryApplication SupportDortaniaOpenCore-Patcher.app"

  postflight do
    system "sudo", "rm", "-f", "ApplicationsOpenCore-Patcher.app"
    system "sudo", "ln", "-s", "LibraryApplication SupportDortaniaOpenCore-Patcher.app", "Applications"
  end

  uninstall_postflight do
    system "sudo", "rm", "-f", "ApplicationsOpenCore-Patcher.app"
  end
end