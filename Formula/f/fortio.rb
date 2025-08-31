class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.71.2",
      revision: "2f4a48ecbaaba5ecd770962e1993056861304677"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d67f3c640f9e7324083760a695e471753ba21e88b082cd2540acc02b3acd05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9d67f3c640f9e7324083760a695e471753ba21e88b082cd2540acc02b3acd05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9d67f3c640f9e7324083760a695e471753ba21e88b082cd2540acc02b3acd05"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b61226f6773a6e6469de051c0623e38949121525b8241275e15b6722483e864"
    sha256 cellar: :any_skip_relocation, ventura:       "1b61226f6773a6e6469de051c0623e38949121525b8241275e15b6722483e864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f51a5e9448056966542d7649c5c35ab4b82ae0cba9bf8c72da069354a2d303b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cae16f769058defc011aecad601e5237c346e34bff04bd988059642d54f49c14"
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