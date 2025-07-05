class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.11.1.tar.gz"
  sha256 "c6d9bfa377f96d9ec08708092a7843b91f58dcc00acfa743febff3c463eb993a"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2df51db41eb64f35a3e5dbc5697114e02e4fc75e9947c8ee3aad7a099c15d61c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2df51db41eb64f35a3e5dbc5697114e02e4fc75e9947c8ee3aad7a099c15d61c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2df51db41eb64f35a3e5dbc5697114e02e4fc75e9947c8ee3aad7a099c15d61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5312d314de4d55accbc5f106788b0e2df4933a91cf69e1cdd1d6796fff45b511"
    sha256 cellar: :any_skip_relocation, ventura:       "5312d314de4d55accbc5f106788b0e2df4933a91cf69e1cdd1d6796fff45b511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ec3d3ca8c89840857e05f92edcf9e8d584f2e8323dd2bb9c9c373f3270e1c83"
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