class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghproxy.com/https://github.com/jeessy2/ddns-go/archive/refs/tags/v5.4.1.tar.gz"
  sha256 "7b36a263fad879131619eb6d8801f73f9a0b8e1f14016b57018c975f1bb6583b"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c36dc53dde98015e0ce70896dc76a0488fbdf07bb74d223276dd32734ca3da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1c36dc53dde98015e0ce70896dc76a0488fbdf07bb74d223276dd32734ca3da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1c36dc53dde98015e0ce70896dc76a0488fbdf07bb74d223276dd32734ca3da"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e6128fcc9dc5dcc7f80f635a8006264944536fd6b53a0ce5ad33bb74c9e75a"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e6128fcc9dc5dcc7f80f635a8006264944536fd6b53a0ce5ad33bb74c9e75a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2e6128fcc9dc5dcc7f80f635a8006264944536fd6b53a0ce5ad33bb74c9e75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17678b465041e47765586caa089acea17efcee2162d72fe9129bea93ec917c3c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_equal "[]", output
  end
end