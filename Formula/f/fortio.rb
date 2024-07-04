class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.66.0",
      revision: "4a1aff9df0c5102caba93b9aadb5d190eeeb6de7"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "700a49b0f97703f34e7bb6eeb52822fca77a37b60aeec4919b8f8f4e05aa6bce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4d657212f3d4eb3d751d11f60655ef04e0add705d7a68fb569ef7ecaa1540c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b75b7cc0e8f6f6570ed171e42d863425eb36dceae45485507e776ceedb413822"
    sha256 cellar: :any_skip_relocation, sonoma:         "473dd547583a734cf541e03877679e276c9c73d37642d711c1759bcee26c6b67"
    sha256 cellar: :any_skip_relocation, ventura:        "8c81014d9596e7cdb17edb21802f01f11ddd86c8de52f43b1fdadc6dd57e9f50"
    sha256 cellar: :any_skip_relocation, monterey:       "e83d9a8a4483d928c4a71aa334ebc8a2cb8e40d310ce6545b34722f36516f4d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82165d45d16de5afafa3cddd7f4acdd23d10196d83af0c086a3dca9656c5bd8d"
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