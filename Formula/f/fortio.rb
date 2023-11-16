class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.61.0",
      revision: "f35afd8d70fe75b6ed8a2c6b56b54d6ee4e2eb36"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f69190a6b308f37f1555654293d9ab2ddb5ea271e9edce320d338e954f16777"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a25abe02891bdcebed9bdbd5ce4a769f29a64d66389bdd5180ef0305ef40fa7a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e906e231643cda910a26e3f845487e8b3c7507bfdc915b09daaa777a2153cba"
    sha256 cellar: :any_skip_relocation, sonoma:         "c15721cb7f255794904e58ec67a76a26268794e819fbe5d9744278e63f191b95"
    sha256 cellar: :any_skip_relocation, ventura:        "2941f8574a94f8b01d86d3f23b670b94afa99cf5b7487a481308689dad2fdb0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b71235d151d43e61f5969230f79942adcf8711d91eb45c4d068fdaf278c83eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e504e133b2d95c6e48c2bb14fb17372684cd625349a438a759659be7eb91a7ec"
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