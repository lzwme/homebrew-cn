cask "endless-sky-high-dpi" do
  version "0.10.10"
  sha256 "b10d61befc3a63d64ef23de0dda53f0da1dad297459987927b170b17c2654a00"

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