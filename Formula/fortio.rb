class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.54.1",
      revision: "e3eb219b4181cec6c655df44b0ac4ca064eecd95"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1567578ec8e2731d5e4bbc0a0b539928ae2614f7c7c0a273de2861e1b9da9549"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d8dc78fb51c0b0342554fb2144d7b69f0f16944c08069ca77df0e355e8cdaca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae4785564cfab0526fa34e27f75e8a1a9bb65d08b112cbc0a0fa761f074930c3"
    sha256 cellar: :any_skip_relocation, ventura:        "eac20c3b3ad7d2f03e7045f27241df787c8977d00f5524f839d9bfcba5658554"
    sha256 cellar: :any_skip_relocation, monterey:       "c012003177c6b921f58a35de5845682323261ff45572d119ea4ee89881322e56"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbb716fb8f9ba34648dcd61a3cd9c04d4b4b41a98ddcb76f1450caca7e880e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c8f0284a261f57605e208401b8c290e02f70dcf86add91c504ac9ac197d7bd5"
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