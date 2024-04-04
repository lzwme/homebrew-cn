class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.63.6",
      revision: "a184337d9e32e639f88c57f89de4dddbb9c5bc07"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f28d88a81569a8f26db2ff1812e04cb4aac5621b90b27f8dffe9bbb64bfb15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1a5310a4f54dcffe8dcd5eb4d083d97edb436ac486db87f56d35d5610db199"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cceeb1b061ee45e7ddf88eac12e27b365b438e5795f325b2163fb65d0e912f04"
    sha256 cellar: :any_skip_relocation, sonoma:         "fac59505e79779f7f85e84b5ee19f87e9885d0034e3abeb4e5f2720822ead5db"
    sha256 cellar: :any_skip_relocation, ventura:        "64b5029b15e2f0f81f719753658112094247afaa1c146b52bfb8f3c56ad3cd29"
    sha256 cellar: :any_skip_relocation, monterey:       "0dcf8a3b1b91ddda5b0eb28e5f00e8d0176dc42ac51bb1e470f477861f84030a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9da2ec825ae2b8507daca7e5142cd42e42734b3bca7b81249f8900c6bf17293b"
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