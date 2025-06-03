class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https:syncthing.net"
  url "https:github.comsyncthingsyncthingarchiverefstagsv1.29.7.tar.gz"
  sha256 "0e2f2574334fc65220977156caffc521314298c43b361a669ea3ea0507267652"
  license "MPL-2.0"
  head "https:github.comsyncthingsyncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ebb7dcd24232e86e3503119fd9e11c369f5cb65cafa1c4579d18dceb85d6374"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7516a3b4b2c8ebbe51d3f8df2d79a33587b1db42700d6b6fa1272639148b86f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd6a1f8ea86daedc6df076d53db2b26be221f0a8d3f7a5887bf88f6fcbd84fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd12ebbd0f7cdfbe074996a76d31b223667d31f5435021cbf74422b697f5b2bc"
    sha256 cellar: :any_skip_relocation, ventura:       "383e2a9d569644ba8f161888b896384d261dc33b5205ff68a41dbfd9c1aadbf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fd4cc71e5cba4d6f22de2612d8a43763c794bd798ae97ca55beca44d3769fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66a3996d83860848fc95a3787d339a8bf7afd6da3c743048b1cbda2127e6129"
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