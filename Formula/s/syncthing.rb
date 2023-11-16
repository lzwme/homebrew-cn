class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "fcb6933f0e6cd3825f40f59986ab19a1a9fdd3f1a65c0fad935c71a32bc441d5"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fdba5836720109736974b0c73dedaf831b70a24c4debc7bb372886c65d3b4e94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d82d57eed76d5c17bd55231113a00af6d3713fbe04060463271d1dbfd1b2147b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a73aade83688633e18ff63b2276b3f40c84818bed8c198ac98373f508b45ee98"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e6aee91c925d0b170aaac3b843f7337aa4c4702ee2a04cc97f28b7399c75ed2"
    sha256 cellar: :any_skip_relocation, ventura:        "abadf28ba9312f3cddf05e4d8c80f912ac1fb74261b0dce23ce322d045ab2118"
    sha256 cellar: :any_skip_relocation, monterey:       "358d1371af1facde12235f1776a2c8d1e9bd4efa6932c46da9e5fd5976bd495a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c50fd96f48e108628156793af03e7e33164f4e51553913cd148903f213e00d0"
  end

  depends_on "go" => :build

  def install
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    system "go", "run", "build.go", "--version", build_version, "--no-upgrade", "tar"
    bin.install "syncthing"

    man1.install Dir["man/*.1"]
    man5.install Dir["man/*.5"]
    man7.install Dir["man/*.7"]
  end

  service do
    run [opt_bin/"syncthing", "-no-browser", "-no-restart"]
    keep_alive true
    log_path var/"log/syncthing.log"
    error_log_path var/"log/syncthing.log"
  end

  test do
    build_version = build.head? ? "v0.0.0-#{version}" : "v#{version}"
    assert_match "syncthing #{build_version} ", shell_output("#{bin}/syncthing --version")
    system bin/"syncthing", "-generate", "./"
  end
end