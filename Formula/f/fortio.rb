class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.69.0",
      revision: "86508a82494764583791991604c98579ae44abdc"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9233b995d0a15f102f67fae62bfee0f9dd11f46832552d2f3dde671b594ea89e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "887fc727d8dfc2df7f887c476c5fe1e6ffcede6d233df7685e18b7909b351e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "844c29de824a1d5eacdb45382de5c228a3c81e9ee1415cd3c5a49ceff52d65b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6f8ad04df8e998e4e5096dba78b97cec7b5f5bee99bba9c6a2a56826c88958a"
    sha256 cellar: :any_skip_relocation, ventura:       "7bd0d88d122c8b2387be133cab7a2b9476238e7e13b657b2c8106c30b86d0bea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99553b1e32232afaf3fe0ba872ee3f8ed9f5332ff0f521eb1d98cc56974d0c56"
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