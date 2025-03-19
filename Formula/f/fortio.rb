class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.68.1",
      revision: "2a4e270ba82a310bfa4cb7429b5f7eb86270c6a6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8391c3e5cdcaa70fd05743b1848f48a89f2bcca60dd6ea65b2c0d20e3c5075e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e04d872e894d6bb0cad33649cff1a6143a0eeaac8507883921d7a69d579f5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d3eeb4503585d1cbe6a4b5ec6e4414a24c38413f2b749044b050100b9477ff6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95ac90d00a03de41e77f01d5f9d36cf9b23eb30fe82fe7acda6f38002a832798"
    sha256 cellar: :any_skip_relocation, ventura:       "41f3232568cd9f85e5e3b3831ab93c64a18156733cdf801e98ddad67bdaa55b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa9604789bb963a59f5dca0a7a37cdab7ae154a3efce65e7147d1b3a31949aa9"
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