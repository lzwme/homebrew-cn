class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.66.3",
      revision: "7074435c28f507d2ca8585a5566515901de20dcd"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d442b03532b62a92aee446f36d56631e52de5d515a8fcaa159d36e8f15089abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484b49e62d67725e76ba85bb23e531f633082fd32c9a43ef53e64345bf030f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7fd70b49da195af9909307086d550a2179def83568ac6b9de8b93c266a0cc580"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2c283a90489ac43c16e96a7947815c1ea70b778e157861666f12bf3bbf7a0fc"
    sha256 cellar: :any_skip_relocation, ventura:       "84b29e0a8fd5a8acc218f3b43a120cc3215d016594d63c08a8cc7b21bbf912d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65492b80f0f5356c74738c462127a48cd5113dec89b83d6ccb46f08e7d503708"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}fortio",
      "BUILD_DIR=.tmpfortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}fortio version")

    port = free_port
    begin
      pid = fork do
        exec bin"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}fortio load http:localhost:#{port} 2>&1")
      assert_match(^All\sdone, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end