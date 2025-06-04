class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.9.5.tar.gz"
  sha256 "b84ef5cfe1db70dee2f15e58e396407625d8a2ce3582ab414608ac7fd2200d90"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36dce839497f8139fd6ba2c4d7b08f4bdfdd904232661202699aea1ddc9807b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b36dce839497f8139fd6ba2c4d7b08f4bdfdd904232661202699aea1ddc9807b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b36dce839497f8139fd6ba2c4d7b08f4bdfdd904232661202699aea1ddc9807b"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c6fe0a6cd1a24ccb1d6edf89b290ec04e75ec04f6d8a79c485e6d195eab2e2"
    sha256 cellar: :any_skip_relocation, ventura:       "38c6fe0a6cd1a24ccb1d6edf89b290ec04e75ec04f6d8a79c485e6d195eab2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1830545656ff61b38e4c3388c974dc8bb076c999cdf75025dda379c3792238a1"
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