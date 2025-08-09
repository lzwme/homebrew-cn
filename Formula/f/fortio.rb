class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.71.0",
      revision: "5c5f287c1df641999fbf1cfb7db583f49ed3b626"
  license "Apache-2.0"
  head "https://github.com/fortio/fortio.git", branch: "master"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de93819b8da6457c43c04ae00f7ce4fc18edc9d423762633171967bb4bf2719f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de93819b8da6457c43c04ae00f7ce4fc18edc9d423762633171967bb4bf2719f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de93819b8da6457c43c04ae00f7ce4fc18edc9d423762633171967bb4bf2719f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5bb7aa93a11b767d0516ad916773ced688b2a9871ad5c6f3993909d555c93db"
    sha256 cellar: :any_skip_relocation, ventura:       "a5bb7aa93a11b767d0516ad916773ced688b2a9871ad5c6f3993909d555c93db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86dd838c219690fc1e5138c11c02a64c8798ffb7e4f58e7cf4a462dc21a17f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b155dfcbf6ea8309c3e28508a4ad1cc4cd960e11acc93dd723a4622e44f33370"
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