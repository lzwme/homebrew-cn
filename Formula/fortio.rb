class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.55.1",
      revision: "b80d012cd7ee3df17e3e9f1ec644efb68abab47d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73ef75ae6a2d91e5a69a24697fa00a639793e6cc4792aa9ac487c3f979af2117"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d6a185eaba0a09450822c1d6f97cdd5efb33ce2c0888d9f345e5de8bddf937e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "862e90b248660a70215f3e0edd9ea53f1b7815cd912bd352808fd70c2328f74d"
    sha256 cellar: :any_skip_relocation, ventura:        "ac79d43b580d33efcdde91a348fe63e402f40d6e3490c31ca76a044409c1e0dc"
    sha256 cellar: :any_skip_relocation, monterey:       "c113dd3ef129a14a4a66552eaf92db0537fca6a8178ad73a86219e7906df744a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bdb0d8fdeabacb9b1660c2c0ee987ec2fe2773e2da376335dc759cfb198bb2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c8af3a89c267e3029171e0727a7038f01bccd2916726db4b72b9cf8ebd08036"
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