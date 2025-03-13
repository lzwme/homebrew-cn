class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.29.3.tar.gz"
  sha256 "4a09cf616f876acd8c62deb1d245647e718e8ffcf01c374ce6f49ea71aef1098"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ba2c77d43655d0baf685891dc24a835a2f830542da20d60c4cb532d838d9842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c0a3a0616cccb98dc3764be048477ccd1a3cfbeac64450ef75e29a708adbe0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9b93bf6637ac37dcfda901a58209940468021752a59af8eb9e8a16e8a23006c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d269ca1ecf0b1bb4c59792d7cee31bc0607a535a13778469a47e49e3974e9ec"
    sha256 cellar: :any_skip_relocation, ventura:       "3c6f193ad3c59d35e2cffed100f3691757e4c8d5bcbe66d95b6b33583ba3b9aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03bab11c94378d354a971a7f756072426a34ca834252b75c83e8d6335d06d906"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man*.1"]
    man5.install Dir["man*.5"]
    man7.install Dir["man*.7"]
  end

  service do
    run [opt_bin"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var"logsyncthing.log"
    error_log_path var"logsyncthing.log"
  end

  test do
    assert_match "syncthing v#{version} ", shell_output("#{bin}syncthing --version")
    system bin"syncthing", "-generate", "."
  end
end