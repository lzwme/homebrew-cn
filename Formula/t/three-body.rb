class ThreeBody < Formula
  desc "三体编程语言 Three Body Language written in Rust"
  homepage "https://github.com/rustq/3body-lang"
  url "https://ghproxy.com/https://github.com/rustq/3body-lang/archive/refs/tags/0.4.1.tar.gz"
  sha256 "5ecda3677b713060b3fc4cc3b4e2ecd54ff0d6e39a1a8407a6d50779f68c9f2a"
  license "MIT"
  head "https://github.com/rustq/3body-lang.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0c8375cb80ffd8fd0c4ca393be24e57fc8c7327cabae321b830a7db02931a9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e8523866b27c1dfb45ed0c13d1b24c18ed6ec2c4836ecc4401249b7a3bb3569"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef6d95796eccb66b3320591987705e4914a17814dd2d79224f7eacf3b823dc75"
    sha256 cellar: :any_skip_relocation, sonoma:         "46872d5d929316e38109e71eaaf12d1673c5d680e70b5e3caf1d9d94d266f853"
    sha256 cellar: :any_skip_relocation, ventura:        "596f4ccb126979076f346d7d84a856ee2773a1599a87d421e54f2c61e8688cec"
    sha256 cellar: :any_skip_relocation, monterey:       "39a05eab36df8b7033165daa1800f4ae749537abc2cbc2266d0fc306d46e9de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae0e83755d749ff804ba70d4e3f37abdc7e869a152968dfb9a05047ab29c7fe"
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