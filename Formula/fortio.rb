class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.58.0",
      revision: "fef3d6d3b49815d40e2af4301cddb6f50c95362b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ced5f5ee31e44e0659babcf13ee0aeb34d8951deeeca140816b97f52f398676"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc23bb465a268c0e3d17a252ca054dbcfb2fa5668ff45e251788de31756eec3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd24e006438466d5791d572303ea12b0ef1dc5e416cbf260ebd2594932658abe"
    sha256 cellar: :any_skip_relocation, ventura:        "cb908a86dd64047c88a995af7b79d238d6c3894c2775da1232a35bdc342fad99"
    sha256 cellar: :any_skip_relocation, monterey:       "373ffaeb4889fe84397aa1dcfcbbc04f4d785c6a07293bc6ce891b84324394d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cadd4cda70b9c6874f4bf806aa00aa2353b90e86ac880640637e4e7a5a1e7ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ab303a166107319491bf1ffa2b85f0747fdd919570c2b3a6d97dee0f2fa1059"
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