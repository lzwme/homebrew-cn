class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.66.2",
      revision: "582d82a75a3172cc40eb0fe8e807c753b2a53770"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7845837176b4628eadddabe6af4c473ce50b9aee74b0b601638951d7dc5ca863"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40200b77bbe4ce6f7f0642b5504cda1a10b3cf609c7cb392d1675fa99cbb7760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ecdd369b6f4f62ee6d4d329a77697023521b69c5f149b107250a141505f6161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "192c6ed069441fd86b9a62a602ed8b130aff8568f008a17f741a8b215fb4f904"
    sha256 cellar: :any_skip_relocation, sonoma:         "2abf8cca7477ce14f2e7220fc427c6b6ddc04b98cd90d373eab30fd68196d0b2"
    sha256 cellar: :any_skip_relocation, ventura:        "3cf3a21b2f3b5ef2579e6113b46ea8c93bfadbe671a63c3f3aa39c63d66db3cc"
    sha256 cellar: :any_skip_relocation, monterey:       "651aa95613c16b678cf67f04d4f47910e5b638e726a9c665529e31b213473ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67781eb9ce3992055dcf4f74d5bdb28f48569c893622e8a3cb906fdcf8165a2"
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