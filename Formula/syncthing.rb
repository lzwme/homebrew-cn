class Syncthing < Formula
  desc "Open source continuous file synchronization application"
  homepage "https://syncthing.net/"
  url "https://ghproxy.com/https://github.com/syncthing/syncthing/archive/v1.23.3.tar.gz"
  sha256 "05dbc2dc2dff9d15a3d6cb4d215b72f59801b791e0052396b4320717197023d1"
  license "MPL-2.0"
  head "https://github.com/syncthing/syncthing.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e84d85215680279e723e44ee2dbfe67f84a968d7f191822eb897cc8981a31e18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536f962232960a824e010b3b87d020ecbfc78657606e96df156665443dab47d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f2d585331e2e0ca0a2907d9ab1671237c1a4c6d038144983ed16096f67a0dba"
    sha256 cellar: :any_skip_relocation, ventura:        "938418042210bcf712e6c8be9f02209f3026c83a7e7634d53f5401f7cdd9c4c3"
    sha256 cellar: :any_skip_relocation, monterey:       "6755f6def048e2707878c0e49e3565a8e434768bd65efb62a5470dc70373f969"
    sha256 cellar: :any_skip_relocation, big_sur:        "c197bc449311ac51ae86da76acca87f9615def8d0f804a84b161f410da0d5e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92de33dc40f5edc6ef0bacbceeaba5ce1bafeacdb4d8ebb8c8599d1e13284ba5"
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