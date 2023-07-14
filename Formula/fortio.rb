class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.57.3",
      revision: "c1c5e58906de3bb19779c1545d3a70bd649b3e63"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44aa2d112a106845208facbc282744c4e9164bace38a4741ddf516314c5b5a4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e21673f9876bb766282d141a22b1002df1bedb2376263272300e474ff660a8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d69d3ba3091ceea579f07f49e4a0d98b149c90755e546525119e155ec7bf2409"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf66078b7b83d3a7b7f661959d2960963e4260a8e83afacade819b736295a6c"
    sha256 cellar: :any_skip_relocation, monterey:       "f679fa4a0fa79d1eb719d770d99cfdd8d203ac58802ff2b719573e4459bd4595"
    sha256 cellar: :any_skip_relocation, big_sur:        "32eabc69eaa17a90aa2969405d8a6a7af435a25c052454a72466e5fc23b42106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dadac1ef2608570eb3ef9fd911eb80af8c56cc11728d964209530e0128fd2233"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end