class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://ghproxy.com/https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.13.tar.gz"
  sha256 "23f375ad739261774ce62a13f7f9c04338e72cdfc5aaa6a59dbc06b0e01f8e8a"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bff0c1dfa7b531108d98b512bf450f927d81e56c5ca27381e936f5a5c188470"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15c43151e2ec57575ecded7dd02377c206f8baacaabc3afa65ee0eea606d727a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb87a90b33bb3969be07d3374d9df6a2e5f31bf1963afce71179c05a9ff8cedb"
    sha256 cellar: :any_skip_relocation, sonoma:         "29aedfb10e26b21582be5fc540fbdff7e7124a0448f0305c8bb9c63a273bded6"
    sha256 cellar: :any_skip_relocation, ventura:        "b04897d87ebaf739fd7d40e34e7ce27a81408909674a8d31e70c32b318567992"
    sha256 cellar: :any_skip_relocation, monterey:       "87a714a70b6676bc20e628ff3aaac087a9b3ad63046d6b85f883edece95c42d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f10685be71d787ee52956847dae6c0668166e7ea9c7abcc76b78663c35aa4d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end