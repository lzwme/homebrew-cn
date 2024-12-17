cask "qdesktop" do
  version "0.1.2,6"
  sha256 "80091362a4350baf14aa0d78eae0078ee974f68b9fa440a75569a4e591d3813a"

  url "https:github.comqvacuaqdesktopreleasesdownloadv#{version.csv.first}-#{version.csv.second}Qdesktop-#{version.csv.first}.zip"
  name "Qdesktop"
  desc "App to set a website as the desktop background"
  homepage "https:github.comqvacuaqdesktop"

  disable! date: "2024-12-16", because: :discontinued

  app "Qdesktop.app"
end