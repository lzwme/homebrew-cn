class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.60.2",
      revision: "058ac0fa4dcba33d908aed396104c3fdfae06a8e"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aef89b578cee9c07ca26140ed22bedc29940781d0e64ba32b006c6e9dc353b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df8c87536bc16c2c4c13c140d98f116496a03de19c07f64374627b6288d45054"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab723f319add3be2b1b874609be299d5b030c46d57932bd610bd6cbcc882c9a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b1fdc00020dd8678dc98523b74df24fdfc4a24d7988530d0051a0bcf99006ad"
    sha256 cellar: :any_skip_relocation, ventura:        "1476e041b52828abb7abf5e3551704853bd9eca17e407b93de830c8f3ad020dd"
    sha256 cellar: :any_skip_relocation, monterey:       "687b12282c958686d6c170360eee5bf90ea76480d8fd01b542a0bda8835e46d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece73396df135a6b93149affcad39e16dcb1f7aac037aaac254d17bc2ebb6ab1"
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