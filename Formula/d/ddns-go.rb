class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.6.0.tar.gz"
  sha256 "68949f25618f461a1a34ee0b3a2ae871071e1d22a7e47efd7763328c98e674f7"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57a11a4b3632045cf50ae14c2188829d3387880bf8eea478666f257630ff155f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc2058420b402ef36c8bae95190e2ce3f1262a5dc01a13d1d4a40d2f52e213f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62bdc3780179d5da81bccd1b860d811092e1eec240a19402992b8812c35a5338"
    sha256 cellar: :any_skip_relocation, sonoma:         "050d0c57b31f530eabef72a1903bd0856089e93f62222f5944f470dc4626f237"
    sha256 cellar: :any_skip_relocation, ventura:        "2f17871c6cbb1973dea4bbd73f4b3119f60e308646b5763989acb13a09280c8e"
    sha256 cellar: :any_skip_relocation, monterey:       "d325a97dfb867653aeb5cd756f2e5c3fe9f1c2f36fea1d66b862cd9acdd0ef52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c34e8fcff0a9ffb982b0f6171fde7bb2d579f31b754da17a38b88cda69caad6a"
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
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_match "Temporary Redirect", output
  end
end