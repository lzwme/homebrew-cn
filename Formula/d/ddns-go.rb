class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.16.6.tar.gz"
  sha256 "60505ad420882c5f64b45d449e8cd9f37e5cc4189558609b0f14aeca71ab0bda"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7fc7bc3515296219ef705423c381e1a8d41c1289748c5addf5df6d8b15299a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7fc7bc3515296219ef705423c381e1a8d41c1289748c5addf5df6d8b15299a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fc7bc3515296219ef705423c381e1a8d41c1289748c5addf5df6d8b15299a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "df63eab2a51e0ab2eaf55571a28632075d8c1e0794e00601384c2ffaca082b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8084e90f2475aa9556073a131d2d1260238d064f71484b8936c41457660d94c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60b70ae7b9c259cb19cd13417226a22a1cec09ae8b7ab10dda7dc44b1335df36"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ddns-go -v")

    port = free_port
    spawn "#{bin}/ddns-go -l :#{port} -c #{testpath}/ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}/clearLog"
    output = shell_output("curl --silent localhost:#{port}/logs")
    assert_match "Temporary Redirect", output
  end
end