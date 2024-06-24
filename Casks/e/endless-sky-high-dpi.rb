cask "endless-sky-high-dpi" do
  version "0.10.8"
  sha256 "4f1f4a5ae02f19ccec074717f243d8a15d70c7ed224a886f83fb623dbece34c6"

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