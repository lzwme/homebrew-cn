class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://ghproxy.com/https://github.com/pkolaczk/fclones/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "4fca70bb3f660bffbf3f473bcd9d3cba52830892f2e62dafa315be7b32985340"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6498440023ca9a33bf289fc36eef7fee8bb7c12d3bb539619ec01169272b9fff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eedd4067f3c493e20490b4f841640c7a1d7c0ccc6fb15082ca51acf5e0f60dea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a132dcc9847fd6981c56d0649b96948594ff2ce7ca9c6f68f7a67fc4dbf39ee"
    sha256 cellar: :any_skip_relocation, ventura:        "b52672b96f750e3646791bc753d06917da1f988bb563bce26a993583ece5148c"
    sha256 cellar: :any_skip_relocation, monterey:       "0f3252a549b5b2b406c9bed718e0565f2957abfa126739ea18d51e7cd0198007"
    sha256 cellar: :any_skip_relocation, big_sur:        "295af4ad7796a64db0f37432cb20a3d99f5c495616180d3d36ba134a5586d91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5914fbdcda3ec68f9ae4d33611ac12ef98a9bdff7ca43a7731c59368f9faa0b3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("#{bin}/fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "2c28c7a023ea186855cfa528bb7e70a9", output
    assert_match "e7c4901ca83ec8cb7e41399ff071aa16", output
  end
end