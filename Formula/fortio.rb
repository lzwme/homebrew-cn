class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.57.0",
      revision: "6a72267d153989a169e2d86ba901ade26cddf950"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb08ed318fa2f9b3e1f0d9b2550822a3740b2267f72d6dbf878982461b94eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e9004d4829624050f42f12d79a58ee919aa841ced49bac1d3e18eb9406a56c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f608477156fdae89e9d23f14ccbfb5782a86ae06c644ba111732a2deb7495497"
    sha256 cellar: :any_skip_relocation, ventura:        "4e46b4942d5e58af0f44c592548cc8618598d0374f364f6728dfc68e6009150b"
    sha256 cellar: :any_skip_relocation, monterey:       "c428c5cf2ef3d0884db7f6c3e0383fc3357bef4b83f68a9e290b0ae48a444c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "73ddcc1b7ffb4b40c13a5e067f41191bc0e178f20ca355bd80cfa7ff98c633e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf76996a7dc1ded9c4abb2b2282cbb4118d77874a3cb5aa20c38398dc796868"
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