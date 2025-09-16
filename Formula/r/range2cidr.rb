class Range2cidr < Formula
  desc "Converts IP ranges to CIDRs"
  homepage "https://ipinfo.io"
  url "https://ghfast.top/https://github.com/ipinfo/cli/archive/refs/tags/range2cidr-1.3.0.tar.gz"
  sha256 "562f130483c8c7b2d376f8b0325392136f53e74912c879fae0677ffe46299738"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^range2cidr[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "222dc28cb19073d0c6d8a68b9a6d26085c247600eb7d99ae4140a46fe78172a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8ce7fa7b06bdbc333fb6b71d512de6d2c6f040df3123fe3b77662e1562606be4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b538cd77fd79f1edbf41c0c74ba289c62ae51d8870712f2b56f5be2f7a1031e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "719332735abc456c90e585fc8f802e418bb9a1d56c6871f5c27247f077577894"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb9471b5f9b4ea6abefb2a8a3b0ee68125098c66565efb77385e5a5e1a46bbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5514b7e035bfdde163594f595f5e776ac8dd998dbdf548d892be91abf06a0ddd"
    sha256 cellar: :any_skip_relocation, sonoma:         "281b35fa3d1b4294e263c6624e5938051f7fd69de1c418572ea466eaba9c56fd"
    sha256 cellar: :any_skip_relocation, ventura:        "f40f62f155e78760e2471d49cc545afefdbc3943f69b07c6decaef2174c8bd3b"
    sha256 cellar: :any_skip_relocation, monterey:       "7559ea0525e6feaecdc50a741185765d4991dbc34c4c57d4a7b0121a4c9f9647"
    sha256 cellar: :any_skip_relocation, big_sur:        "2103581c5d4bdbac9d5c4e046f2f4344afa65ec6320151a2af2606d4a7a3e617"
    sha256 cellar: :any_skip_relocation, catalina:       "41ed80ac028658ced43c8973c7c29c81fe159347ce885c24384df915157d91e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "738f9617ee60fef2ec1f30930b45dfc633d4f65ccdb97659d9d311aa52eb9c2a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./range2cidr"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/range2cidr --version").chomp
    assert_equal "1.1.1.0/30", shell_output("#{bin}/range2cidr 1.1.1.0-1.1.1.3").chomp
    assert_equal "0.0.0.0/0", shell_output("#{bin}/range2cidr 0.0.0.0-255.255.255.255").chomp
    assert_equal "1.1.1.0/31\n1.1.1.2/32", shell_output("#{bin}/range2cidr 1.1.1.0-1.1.1.2").chomp
  end
end