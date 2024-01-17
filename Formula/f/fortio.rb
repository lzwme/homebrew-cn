class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.63.2",
      revision: "a9a6b4e2e89f813e7f18a0f15270b02e6d3f26af"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3aa18effb721f10a45d9722e3c386a700a193893c738a2cf1b3d3423400b0778"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7500d710a98b9d3c393e9d2e8cb0119540e0d9ca2670ba9f6b4240939992041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f71536f38ce9ae9410bcd7b1ed8a3a3c5923a00c0308febe5de2426ad082a464"
    sha256 cellar: :any_skip_relocation, sonoma:         "a04eef55ca20f2841735ae4a32f8fb86050d5a3128bb9ec96002341468b56cb5"
    sha256 cellar: :any_skip_relocation, ventura:        "16ea1eda3952caa037fdc744bb91557b7af98059b9bc600c69ac2c111581dc56"
    sha256 cellar: :any_skip_relocation, monterey:       "b494ca3845aeb4c36cc119d1c62c33e93e355aa0453e5c7d260e61b8be72b07f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eae42a02ac10c2ced28a33c6a03aaaebf5b847df777eab1d9100c04f5c636917"
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