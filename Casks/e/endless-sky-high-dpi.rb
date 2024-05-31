cask "endless-sky-high-dpi" do
  version "0.10.6"
  sha256 "c297e6278697ab62714d67e05b2acfb5283bc5fcab86d45bd606bb02d90c9a75"

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