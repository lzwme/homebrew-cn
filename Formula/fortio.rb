class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.54.0",
      revision: "69ae5d0f46e052004b565aa97e63de219addbe1c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4583015cdb4d4181cc9647d6ce2ad147baba4efca5c877497191612f8e84b8a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2288d91fd8b8a7d52be0d782167f8800103feeec49c0f058b1e61d6855214db6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0125e7f6e12e0a1a5e1c1f8e58a9cf6419b65576f4f96ba3b679a9a8c2223ba"
    sha256 cellar: :any_skip_relocation, ventura:        "f02d1c670f475b803ba3952f8ab898e3a514b0c4ea5f894e041eab29375925f1"
    sha256 cellar: :any_skip_relocation, monterey:       "7489ca85b872a6a661a573c2affe6c79008a34430f1df0fb8df848202841a42b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a8bebdbe405584d744a340397385a81a9c79e7d77d505b36a199204721ee945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "867507d3efcda04c23890462e95d729bfa7b8f24d4916dd63e13bec23a8c5096"
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