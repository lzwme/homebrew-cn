class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://ghproxy.com/https://github.com/projectdiscovery/mapcidr/archive/refs/tags/v1.1.15.tar.gz"
  sha256 "40df16be0274053bbd714bb1a2a4c333667a40d0a1ce6b37a535e21479df4971"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab96b954aebd065467d4e00f60f2ea43904e06e6a318d403f617699c0811bdf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1f5e6e9ad2e6fcab4be21e251790a00913b53d550cf833327bf7bd32c8fd4fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9553953e9f27c5d1f8a5ee4ae83d506b095a9cf2a9d8cea463ba3f817f8ad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "774c1f0ec461aab1f52359b0e65ad55d103990ff31c615bf10e95575f67c77ec"
    sha256 cellar: :any_skip_relocation, ventura:        "b6054c89a74b315d1041bfd3f0186557c3ebaa4cca3484a89db7166be6e00cdd"
    sha256 cellar: :any_skip_relocation, monterey:       "3327380dedcac9528ca675e7401cdd04141c22ebb4338b4c55e8d64fa07a203e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2ef9e786cf27716306a511404c9dd0d2ebce2e26d83070f8a8dc06b14cb3801"
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