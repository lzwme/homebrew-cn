class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https://github.com/jeessy2/ddns-go"
  url "https://ghfast.top/https://github.com/jeessy2/ddns-go/archive/refs/tags/v6.13.0.tar.gz"
  sha256 "e1d2201d5b237ad55de8cfe3451705fc75a9deeb9765637cfe8c2c362216b4ba"
  license "MIT"
  head "https://github.com/jeessy2/ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45ce14c076f15e7ee6d6691e065d07cecd604b8c20df324fbf169bfbb48091e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ce14c076f15e7ee6d6691e065d07cecd604b8c20df324fbf169bfbb48091e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45ce14c076f15e7ee6d6691e065d07cecd604b8c20df324fbf169bfbb48091e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd03fda12aaaa4d9f7c2f552bdfed24e161e4712fce4433ac12ae73c7b46512b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a109db40e26d5c18bab2510a87a4d308ab9178d7f87499df51c177463ba4973d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6483ee2a8c18cfefc06145e1afa5bee8e4e8fe099b93ac475cfbf8a68464a65c"
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