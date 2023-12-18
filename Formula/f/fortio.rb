class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.63.0",
      revision: "6b492e20fffc070f3ab624cf960793a01651cd19"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1d3104c6259cb7201aa315949ea5b69e83207bad03671bd461a6394c502a613"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "276c789b7c0c8e2df58edf2f348333fbe3492880e740178881dc5a8642a953b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d37c236510992dce18e9020c1d2f8db51e37d6b411d88ef19ad7006352fe55b"
    sha256 cellar: :any_skip_relocation, sonoma:         "050d19d1b6303e82d829e683291f02d875a72efdbc482afbd212478a06dcf93c"
    sha256 cellar: :any_skip_relocation, ventura:        "b7790b8ae9524e042e860b31a7ff9a04e4497e68d8d7355e14dc931cc019cb9e"
    sha256 cellar: :any_skip_relocation, monterey:       "d7f97ce70e45e6e23a9296e442283cb5a7f3817f72711dc0d6e2ff1fdb1e3531"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3311f50abb35513751670b02d39d7c39ceef479587baccb674eab93a817abe5d"
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