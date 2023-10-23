class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://ghproxy.com/https://github.com/pkolaczk/fclones/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "7a876743a84f0ff367a47dfc0e37587b9ed07618decbfe1914945a2b334ae382"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd9b6d5797fa0684a7ee8ca65474f9df0e945bb471d9a46613652b3ea30d759f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb46eeae970e16f81668d2e6d257b6793c03d6e07070ff17d33c4f4db0ceebe6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d727f8c12f64a01d27f4a5ac351190d1f837363ee0d266345365708ed36cf4a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b6a50011892b5d18ced26cfc4633a48b6d1103771d64e5b30ec090f7ff6b3ed"
    sha256 cellar: :any_skip_relocation, ventura:        "c2b33af5df8a3d4175a0e09c5e8c48d339e7c0c3693ea701ad8e4aa8cef994db"
    sha256 cellar: :any_skip_relocation, monterey:       "8df7819cae0e6c1ca66767bbdf4d68c1a2a1336aa3dec856cf80178319bdcad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c385e383aed895e45334cbcbd2c2f483bbf25339863eccefa921e52eced69d44"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "fclones")
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