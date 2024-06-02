cask "opencore-legacy-patcher" do
  version "1.5.0"
  sha256 "1339b694899a0aec51dd32b20f9e7b84df6be08aac56837a94d2bfaf806c155e"

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