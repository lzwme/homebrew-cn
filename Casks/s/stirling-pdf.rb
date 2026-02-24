cask "stirling-pdf" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.5.3"
  sha256 arm:   "26052eb8b54e6efaa511b421336369861abf0d9a1dedaead7ec44e44c47e511f",
         intel: "08e531273caedc85166536fc679a6cf884332341cf9d9de2c430d1c6f084d353"

  url "https://ghfast.top/https://github.com/Stirling-Tools/Stirling-PDF/releases/download/v#{version}/Stirling-PDF-macos-#{arch}.dmg",
      verified: "github.com/Stirling-Tools/Stirling-PDF/"
  name "Stirling-PDF"
  desc "PDF utility"
  homepage "https://stirlingpdf.com/"

  app "Stirling-PDF.app"

  zap trash: [
    "~/Library/Application Support/stirling.pdf.dev",
    "~/Library/Caches/stirling.pdf.dev",
    "~/Library/Logs/Stirling-PDF",
    "~/Library/Logs/stirling.pdf.dev",
    "~/Library/WebKit/stirling.pdf.dev",
  ]
end