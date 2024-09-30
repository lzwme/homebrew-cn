cask "endless-sky-high-dpi" do
  version "0.10.9"
  sha256 "e2e279a262ff7166cab1d595fc61a8364259d6a446f6ed8064feaf7b753b1230"

  url "https:github.comendless-skyendless-sky-high-dpiarchiverefstagsv#{version}.tar.gz",
      verified: "github.comendless-skyendless-sky-high-dpi"
  name "Endless Sky High-DPI"
  desc "High-DPI plugin for Endless Sky"
  homepage "https:endless-sky.github.io"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "endless-sky"

  highdpi_dir = "endless-sky-high-dpi-#{version}"
  artifact highdpi_dir, target: "~LibraryApplication Supportendless-skyplugins#{highdpi_dir}"

  zap trash: "~LibraryApplication Supportendless-skyplugins#{highdpi_dir}"
end