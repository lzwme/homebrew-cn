class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.0.0.tar.gz"
  sha256 "db7da87e1691f11ebc5b49dffb1e7ab3df243d3713e7e139372de30dcf6de15f"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "658e1fe47e1de81eecb07575081050ac984f26d177ad14ce9682526d8327a413"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b47ae3ac80406a10689212e498da8b3366b09e865139d1c98b716e30bc59d889"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8806e4f0edbb747b85c039e2ffa7f1ec14eea9069e7dd46eeebee9f6371175c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "51625bd5108d24aa32ed4a23ff76a9854438aa9bc1839c61bac0feae8fe5c81d"
    sha256 cellar: :any_skip_relocation, ventura:        "1985123ddfe4204cd78892ff21476089b24e67ce0e669260de9c19bcd0d876a5"
    sha256 cellar: :any_skip_relocation, monterey:       "77f3d3aafc9cb88be1335b74dec30865589291c846190e03d0cc56930fbfc48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95c5222e85bd083d3b0d2b627435609f7dabac586bb7b74c6ce513373c15b39"
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
    assert_match version.to_s, shell_output("#{bin}ddns-go -v")

    port = free_port
    spawn "#{bin}ddns-go -l :#{port} -c #{testpath}ddns-go.yaml"
    sleep 1

    system "curl", "--silent", "localhost:#{port}clearLog"
    output = shell_output("curl --silent localhost:#{port}logs")
    assert_equal "[]", output
  end
end