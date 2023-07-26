class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.57.4",
      revision: "67b7744c810d8520599076765f037009164c9f8f"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5e72dd6dde8409448b0861baffe042e6284aa665eede7ee25c4ee60c31f23dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91000ff3c93b04dae7bef7f1c4b3edfd364d60610ce04a8358f16ca66aa2d369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9565de9ab6b7c862df67294dc50ef3f0959f7c51541481297f650ed7f60c8b00"
    sha256 cellar: :any_skip_relocation, ventura:        "f6d419c0ebe400e20608caa6e945460f66ea8616abe1483b193cf6cdecacfe66"
    sha256 cellar: :any_skip_relocation, monterey:       "aa712a4fcd71cb6c38751fb31c7abd7d3af8eb61c1946788a4bc9bf985c016a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "20a0da5d954441265f0b690f27b775199b1b885877f67dab9559e6df79662f45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d2f0c6a74ecc18f22e61f3e0b55ad7a1bc5dd973b5387458721b7631082817"
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