class DdnsGo < Formula
  desc "Simple and easy-to-use DDNS"
  homepage "https:github.comjeessy2ddns-go"
  url "https:github.comjeessy2ddns-goarchiverefstagsv6.0.3.tar.gz"
  sha256 "d6c33a1da8cf580699708939186474d2dd4424c05edbd61a8a73b37946ef288f"
  license "MIT"
  head "https:github.comjeessy2ddns-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0db26568c860197866fae93a1b3ab75254d291c4de1a987b75c8fd71cb1a101"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52de656926f4e541cb62362fa02fc0771be4ad1a410b13f7cd46cb014b5707cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305476ad4445e5a4bf1227eab98282bafc45ff450feb381727fe9a4e97794425"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c81fdfe66985229fcc282d9dd1191a30578e697c73818c2b043b2cf38174e83"
    sha256 cellar: :any_skip_relocation, ventura:        "477342dc019a8cae2b402101b02833beb1a44cc0e1cc4a43982d0d225b4e66c5"
    sha256 cellar: :any_skip_relocation, monterey:       "99d66c8bd254f550717d502a0d1a46d5cc22b87aba85a9339c09d3502307f447"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89abff8bd20ee3c70da58730d9d8e50d2d7c7c1bc23748936e5f0090bc2b88e8"
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