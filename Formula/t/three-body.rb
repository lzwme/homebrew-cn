class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https:github.comrustq3body-lang"
  url "https:github.comrustq3body-langarchiverefstags0.6.4.tar.gz"
  sha256 "403f9ffe82ba251c8b4375edef7ac1145e450fd5b2073bbd7792b120b757139c"
  license "MIT"
  head "https:github.comrustq3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81d6df11101a4a3aba526ecb12e891698c1013059e640762ca8f36bb3e516934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18660a523356ec28fa10832564a6c9c0c01ac77b8cdedec4eb1d48fdd9c355d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2a4fc21bc3aa8fa4b2dcff99e2b516fd9966ce1d357ec073e20c16badc95535a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a88c23365f089a3b54948eb08e7d948a16ada665993a29a6a22804e4c18ff044"
    sha256 cellar: :any_skip_relocation, ventura:       "bc3783e06c220819e6f45d9dbe9985ed1dd1444239eae88067ee1b106faf95cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f00c06ae97d39f94a34c5ad7370f70c30ebe8880de5189c7bfc0250f39db4be"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "\"文明\"", shell_output("#{bin}3body -c '给 岁月 以 \"文明\"; 岁月'").strip
    assert_equal "\"生命\"", shell_output("#{bin}3body -c '给 时光 以 \"生命\"; 时光'").strip
    assert_equal "Error(Can not assign to constant variable 水!)", shell_output("#{bin}3body -c '
      思想钢印 水 = \"剧毒的\";
      水 = \"?\"'").strip
    assert_equal "4", shell_output("#{bin}3body -c '给 自然选择 以 0; 自然选择 前进 4'").strip
    assert_equal "3", shell_output("#{bin}3body -c '给 宇宙 以 { \"维度\": 10 }; 宇宙.维度 降维 7'").strip
    assert_equal "true", shell_output("#{bin}3body -c '这是计划的一部分'").strip
    assert_equal "false", shell_output("#{bin}3body -c '主不在乎'").strip
    assert_equal "3", shell_output("#{bin}3body -c '
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
    assert_equal "\"半人马星系\"", shell_output("#{bin}3body -c '给 三体世界坐标 以 \"半人马星系\"; 广播(三体世界坐标);'").strip
    assert_equal "", shell_output("#{bin}3body -c '冬眠(1000); 二向箔清理(); 毁灭();'").strip
    assert_equal "[builtin function]", shell_output("#{bin}3body -c '程心'").strip
  end
end