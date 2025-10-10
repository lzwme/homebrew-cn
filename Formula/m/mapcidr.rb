class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://ghfast.top/https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.96.tar.gz"
  sha256 "fdf2955f920f2197bcafd90009cae54b6766b890cb1481a673cf44fbf81d867c"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e28c0009ed0514f019e0ffd41e14a4e7159a5914fead3015cc5d1f2185b82f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78655c0b9ed6633a16c7cf12e99d21fe0cdc9debe1fd140ba6cacb8a7bf64c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57aed1540f1169b088e245a8321bbfabb82f4afc5801653a9bcf08be52141792"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cf92d7df7cd70b386e8dfd7da1b7f331a4a0f4abad34ec2e35e6b525348c024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "029235059fe9261644d9ce250c0ee078525e3f3fa5c30a4b88a5cd0cb9381771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7c96bb7fe839fd01b4af3d94703a5c9e3cb8f9fa69ed1fa9d09dfae6f5fc6d0"
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