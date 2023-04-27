class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://ghproxy.com/https://github.com/solidiquis/erdtree/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9e85f1d92ce4668fa4648348e98aed53fdca4bcbf61c2d5ba53174d459693099"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54cc4766235991ea24f3c00b6e18c332e01afcb6be277c8d27c1bfbea1fced44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7877f045b088b4780d90579aae7ca5c8ed4fbcb0369a7c3d5036a20f0cf5c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec2754e71bd16f8504d1015aea47d77f2dd3e9e4432c0114ae9b740d4820006f"
    sha256 cellar: :any_skip_relocation, ventura:        "f7392805a38c4590c4b0230d1910467ee6f0dc32cd1eaf637c358194970c33f0"
    sha256 cellar: :any_skip_relocation, monterey:       "cb8264322dccb0733e36d6f4c83794649cd968f82cd270fafd656e6c3feffd78"
    sha256 cellar: :any_skip_relocation, big_sur:        "64f2a40c3c98ca831a9802c00e86bd1d7c16257442a92d561d04aea707549337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ac86e575ba8672c788420eafce7d03d3ab9d094b5a27d54029ed3fe38065bda"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end