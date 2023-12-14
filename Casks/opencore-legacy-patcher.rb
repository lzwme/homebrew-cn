cask "opencore-legacy-patcher" do
  version "1.3.0"
  sha256 "daaa2655f8094dec5068da258d580a2414193c1789d0ae75662dc4937073bd8c"

  url "https://ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher/"
  name "OpenCore Legacy Patcher"
  desc "Patcher to run Big Sur, Monterey and Ventura (11.x-13.x) on unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app", target: "/Library/Application Support/Dortania/OpenCore-Patcher.app"

  postflight do
    system "sudo", "rm", "-f", "/Applications/OpenCore-Patcher.app"
    system "sudo", "ln", "-s", "/Library/Application Support/Dortania/OpenCore-Patcher.app", "/Applications"
  end

  uninstall_postflight do
    system "sudo", "rm", "-f", "/Applications/OpenCore-Patcher.app"
  end
end