class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https:fortio.org"
  url "https:github.comfortiofortio.git",
      tag:      "v1.63.9",
      revision: "b74aa3d1e84529618f70a994a91d3ac9617abe70"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c0b9bd3c8b34a712be1cc15bced5d8758884c23d817e2e012de67e9c038381a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93c5518ecae8be7637b65b68dd148f9f4d4b3880f7f9d8b809b843b60da0ef87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff242b8c18702605d3f5ab5d5517d28d7b11f2e5f9915879db48a099a5eb50f6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c51858a03e6a5e1ac3ec868146464ed22b3bce5a0f49c5b98c54fa0efc1c104"
    sha256 cellar: :any_skip_relocation, ventura:        "2a539dd78b82894edb5436ca35e795bb26397c1fa49afc2be66fec1cbb4fa009"
    sha256 cellar: :any_skip_relocation, monterey:       "acfec171023ece9316f86e99a1ce4e2029e6c467029ab5e701ba2cf73d2eda22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6f7a7465afa0a064c0fd43c2e7f053901035fd80d43c6d32e9fa3634fe2a31"
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