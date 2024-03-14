cask "opencore-legacy-patcher" do
  version "1.4.2"
  sha256 "bb377c3c1f1341be295288f085097df3e509e2cff70266b7c1a776023796ed65"

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