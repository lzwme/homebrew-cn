class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://ghproxy.com/https://github.com/rustq/3body-lang/releases/download/0.3.1/3body-lang.tar.gz"
  sha256 "889730c614a6c03a73fe26ac88e061f5ce49f0ecca8e76921c9bec094094f0ff"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3911f9bfd1d1893373888d11e3c6301d4884507078b35d94efdc37c6b04b46a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c8df72963f11ae5796ea28f11da9267de853248e0f46f691f47cac97c313ac0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b8daa3b7442bcea72f8c67781fbf76b51d51e7ed8786b8f011554aca664905"
    sha256 cellar: :any_skip_relocation, sonoma:         "18261d790894fb10f56ecb3b83ad0ac1e2df6253cae44c94c36c155a83e3b533"
    sha256 cellar: :any_skip_relocation, ventura:        "35ddfa1e02c57efb77d52aa49602a7cba78d6d9a4d9d0b3e05c0eb0cd9e6e485"
    sha256 cellar: :any_skip_relocation, monterey:       "06bd48f57b5d73f1660b2d511c16adeb461fdde138313f567b335daf8ecb9e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e45520dbbd4609fefc06a5607d1ced0f44927ec507aae26a3b4b4d06a2d3e45"
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