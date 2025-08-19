class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.71.1",
      revision: "bb4c5f63de9a738e5a656527e0d7d25b35cb5a3e"
  license "Apache-2.0"
  head "https://github.com/fortio/fortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecaf18a1c450b19973de9ae226341280095d02fac1377a493404946c2629c2cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecaf18a1c450b19973de9ae226341280095d02fac1377a493404946c2629c2cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecaf18a1c450b19973de9ae226341280095d02fac1377a493404946c2629c2cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4140db6b2e579c4303171d6a838af539875c607d92ccc33e5069d4b2d2d51366"
    sha256 cellar: :any_skip_relocation, ventura:       "4140db6b2e579c4303171d6a838af539875c607d92ccc33e5069d4b2d2d51366"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8481df9947a5a6c8006430bf5315dafa884f0630f62dbf24ce22f5b1313fbeb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d3f6412f29bdfa24c708c0420e2be6f8eb7038a4b90639478339007f7b8812b"
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