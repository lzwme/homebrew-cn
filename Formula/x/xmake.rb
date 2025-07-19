class Xmake < Formula
  desc "Cross-platform build utility based on Lua"
  homepage "https://xmake.io/"
  url "https://ghfast.top/https://github.com/xmake-io/xmake/releases/download/v3.0.1/xmake-v3.0.1.tar.gz"
  sha256 "2b5db9586d57f35392ad59a6386c714598a5148d91acac2945f35a5ed32bef79"
  license "Apache-2.0"
  head "https://github.com/xmake-io/xmake.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ebb0b091e02bd7c81019097c3bec41e385527e5b2809a161d04dcc368a10c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38b79b6dd2011359b4882777d0a6aef80be6c95b63c5c7115966ef12c452c5f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d23ea8979bb1aeba089774c9e2e22948de47002736dfe3f7ae20507f595d4ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "479e23436a290740473135a1520d95abd984c920038ec37c5e6e872369dc48dc"
    sha256 cellar: :any_skip_relocation, ventura:       "406c460a887667aa218ae207131ead0fb0ac178a16432843c8fa9353cd6cf785"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69a50d965ad6b826b183fa6e2b5f8df53152d709be19ee6907efa952e1868dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a857c6bbd5ea07d394da45c8e4754e512242c1061be8a2a3a11ce9787b885fc2"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./configure"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV.delete "CPATH"
    system bin/"xmake", "create", "test"
    cd "test" do
      system bin/"xmake"
      assert_equal "hello world!", shell_output("#{bin}/xmake run").chomp
    end
  end
end