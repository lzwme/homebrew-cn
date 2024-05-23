class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.63.8",
      revision: "a3e1747ec8df4a011c0b2efa3eac9ab80b4ac197"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61b2889f2e2441352d379bd819de8ebe902331786709989eb057e6c0e61452c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7627c77015eca14f30c76c7ce52dfeb47dc81d8c9ddfb8a941d0032966efa742"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d59ea970c4357ec45b9753bc74e479fcdbbd2aff204dc7c2bcf15971301a28a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e4241ea08989046927e409deebc1826ccf612c80b5608ed55bc3caa09aaa7098"
    sha256 cellar: :any_skip_relocation, ventura:        "bc5de04a0e24ff5b3c4bea727b63a0bcbeb32d1a18bbb9e3a886dec843c6d549"
    sha256 cellar: :any_skip_relocation, monterey:       "43f7faebebffaca3256a07af5a2030906e011c02e06ddd5fd563aa41dfd84f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec9a61580ac23fc8ee1530764e5dedc6ab540e25db0b757e115fe2a87a8cec25"
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