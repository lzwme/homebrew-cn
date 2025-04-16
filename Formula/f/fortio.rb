class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.69.2",
      revision: "f984aaff921514bf38b018cf2f46f6a4e46e82c1"
  license "Apache-2.0"
  head "https:github.comfortiofortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17568d1367be30b925bbb0c6ae5bb5cd362783630b7f7ef9f727815760d66cc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dc4af2be0911fe4322fec32540e70ba0cda99d3c97be8e3cbb020bda356ab92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75d81cbda6e3002a349fdbb1f734d11fd5a15db2f10b9c14ebe0227ed71293a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6e0c14037079c40c09c854099ec1bab7e696f6403120063a09f31ebddf47ce7"
    sha256 cellar: :any_skip_relocation, ventura:       "261bdafa5b4ab16fbab1c5faf0802ca81d4f460d4ef1c4d95932c571a62616cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2725c002da751259a8394ff4fd7f08ec9b6338810fef0c20fccf4f19592837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39662cf8c93ff38377a685590c315bf4b641c66220e3d833737e08508ffa4adb"
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