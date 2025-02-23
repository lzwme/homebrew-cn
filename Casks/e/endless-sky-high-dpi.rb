cask "endless-sky-high-dpi" do
  version "0.10.12"
  sha256 "ea44d6a9b76459a99655a49b80fdc1b45d37950f59edf95d5413d9eda3d67e53"

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