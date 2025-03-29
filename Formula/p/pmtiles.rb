class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.27.0.tar.gz"
  sha256 "87d26dde4f32d2a58692e2b5f197ec21e643be24bf1f73faa7b8982e23e84d31"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfd508968ee8017ddb922758f326559eec61fb818fe1fa4b0de0a85de6350c54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfd508968ee8017ddb922758f326559eec61fb818fe1fa4b0de0a85de6350c54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dfd508968ee8017ddb922758f326559eec61fb818fe1fa4b0de0a85de6350c54"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee914945fbc2927c6484c26f52f8bb23799a97c4234aa1c0bdc8b2a158eeceef"
    sha256 cellar: :any_skip_relocation, ventura:       "ee914945fbc2927c6484c26f52f8bb23799a97c4234aa1c0bdc8b2a158eeceef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb4b9d221469c5c1fcf742de23a069be3ac2622334599f05ec816444490bb804"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end