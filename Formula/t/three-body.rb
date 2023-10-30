class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://ghproxy.com/https://github.com/rustq/3body-lang/archive/refs/tags/0.4.0.tar.gz"
  sha256 "7576d970b794af6e365aa23bddee21c5c3aa98ceab58f1817aec852eae795fa1"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "080ff666f698b253371275171a4371c31abe78d8741d80094435971d04705538"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba8242b252838a1283d3525e9b1c0676d842e1b9158f2dbaa5a4f0ac98d6866b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b76db4fda1af9963b9067f4b55fc4a2ba49205d6fac131fff46afc7180a56a37"
    sha256 cellar: :any_skip_relocation, sonoma:         "6550dce4e3121d30ba5742afbff37f327ce0880c15251d3eaa7f2ef676cad13c"
    sha256 cellar: :any_skip_relocation, ventura:        "f6e48103d6fb47740cc7f363d436f1748158046785acaf826f9e3ac3dc5e5c9f"
    sha256 cellar: :any_skip_relocation, monterey:       "399c9079c5d48d65b28ceb626e3cf41adb7b4d7c61de88c9f554a4a897ce9173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1de95665ca84b27bc3f515aa9e58e62328e361e2df1b3b876c01c4d1a77d1840"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "\"文明\"", shell_output("#{bin}/3body -c '给 岁月 以 \"文明\"; 岁月'").strip
    assert_equal "\"生命\"", shell_output("#{bin}/3body -c '给 时光 以 \"生命\"; 时光'").strip
    assert_equal "Error(Can not assign to constant variable 水!)", shell_output("#{bin}/3body -c '
      思想钢印 水 = \"剧毒的\";
      水 = \"?\"'").strip
    assert_equal "4", shell_output("#{bin}/3body -c '给 自然选择 以 0; 自然选择 前进 4'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '给 宇宙 以 { \"维度\": 10 }; 宇宙.维度 降维 7'").strip
    assert_equal "true", shell_output("#{bin}/3body -c '这是计划的一部分'").strip
    assert_equal "false", shell_output("#{bin}/3body -c '主不在乎'").strip
    assert_equal "3", shell_output("#{bin}/3body -c '
      给 水滴 以 法则() {
        给 响 = 0;
        return 法则() {
          响 = 响 + 1; 响
        }
      };
      给 撞 = 水滴();
      撞();
      撞();
      撞()'").strip
    assert_equal "\"半人马星系\"", shell_output("#{bin}/3body -c '给 三体世界坐标 以 \"半人马星系\"; 广播(三体世界坐标);'").strip
    assert_equal "", shell_output("#{bin}/3body -c '冬眠(1000); 二向箔清理(); 毁灭();'").strip
  end
end