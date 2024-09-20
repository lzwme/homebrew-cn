class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.66.5",
      revision: "3af89dc91ec84b52b15015f771dc26d59e10416b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7135bef976606a42c6bc0074bf022f1257e4fcd2453cd53c8c5995845ff1b632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5974dff4b8e0ef64a8a1365525b5926411dee2a715f217ba50b6fc68db6ee85b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e5c680ae26d9c42dc46bef031831f0c0257d4ebe6bcc9541e96b5dbf9fcf54c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "89a8fefb0091e6e170806a966769e63e307020c42beb2f60a4be3ebe64cbe8fa"
    sha256 cellar: :any_skip_relocation, ventura:       "536141c09e85c704bd3d7f6e4849f4752e973be1665b4526c48eefd45ef05eec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40420e79b14fbc436ec542435d031daadc06e5f7825cbc46fe90ba2dc44bcda6"
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