class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.65.0",
      revision: "4f3570b9b1929419363e4664b58e8bceffa207b6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fc279b8c2d5be57ed29aab50e70bcdcfd1faad91cda8f19a4d009523df57fa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd15e0222a9f3806fb390ad26e51c8ce1adfa134b607c7c21b81b8637ff589d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72f4c50904c2068b6a2a487d1f5f45d9e33cea221320f0f731b436164be067a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a1ea57e880a1004ed54e921dcfd128afb63caecf30d9949568b978ec097866e"
    sha256 cellar: :any_skip_relocation, ventura:        "76b47aa7645d8e90e344e609da41fd94b52b7c3682002ccf7b2515169531139b"
    sha256 cellar: :any_skip_relocation, monterey:       "df252713e1dbce0cbd368de4564c06e2ae46b37a3c85559cc7170ab3d1129369"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e2ef5f1780560777a4ec26f2cd8e4e45f39f6a5921fbf008ea62a4a9d0fe39b"
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