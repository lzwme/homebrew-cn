class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.67.0",
      revision: "39daadd7c6dcce3ce3f990240fee9819c617d383"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31b658167c076ac7fa24dcfc3ed791b8529278d65fc8bb3f4e4509b71f9938a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e715ba80e66baf5f89fd1beda5b72869441edf4d0a848bd1d060733e6f7dfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff28d502774fc05b01ec9f449ea0e9e947d62ed7dee0359975d344988d5e69d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2a49f6cc3b97ed7366bdc64777c0a829be8289d3d00bc73fa67ecdc1a87b8b1"
    sha256 cellar: :any_skip_relocation, ventura:       "b3affc3b4e8c42fd79e447205da472e41b1503e561ae91d55e9268ef0144dd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cfa0c6470dc4a4fd3412a1a2dfbb1db5141bdf5cc18dc1892c0f983578e2e60"
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