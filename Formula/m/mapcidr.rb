class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://ghproxy.com/https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.10.tar.gz"
  sha256 "69df34503ecf0910a77a2f8a79adb8c2330a86aebe04fd5279519587f9744519"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "412ea8b818a5587659e00949439bc47204a19e9d2bb4559affb0890944a55cec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8c5ceb7e350e4c69cb391f317bdaa08ca2e47ba64eb1d520a0755f3b0e736c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83f9f03c079f1fcab10fd9952e94b9721327306a7c5ebacd2b7cc7f7f9fb050d"
    sha256 cellar: :any_skip_relocation, sonoma:         "adaaab8488224881b7136da68999ce4b7d403a1fb4b52264afc7da03f438cd16"
    sha256 cellar: :any_skip_relocation, ventura:        "dfbd3fda1b1eb6431d71b42a9e790482ea826833a43c3def9034a8a008b98bd6"
    sha256 cellar: :any_skip_relocation, monterey:       "cc23577a98d8fd21c684c7f758a0cfde236770068786dfce2ed71bfaa6bed734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10d6b1953a4f3d1e3fa43551039390d3409765fbb90e60e2874392e447e81ed"
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