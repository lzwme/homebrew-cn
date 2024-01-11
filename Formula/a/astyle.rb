class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.11.tar.bz2"
  sha256 "15b22bc6cbc038ccd8cef3804efec02f35c6f2538b75c93bc7f76e4de98aba92"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cdeb24df54e45dac87ab976f56c21d1c31726ce2c0f5b8733adfcffcb619b30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bd807af019d31235b2ffcf0b1a42f59149aaea28d22b144680c4ce2f5d236f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86259b8b75cf219db68e53a5c5952f49f25060310f979a535a4eca44bd20299"
    sha256 cellar: :any_skip_relocation, sonoma:         "1af8fbdcb7868a47653e8be8bb8a3a93897af43213979c85211354c6ed608ba9"
    sha256 cellar: :any_skip_relocation, ventura:        "e47ee029cf04ab43709d776f1dedd81300020f36bc1fc8f6336e71f80af57d03"
    sha256 cellar: :any_skip_relocation, monterey:       "b6f209074d36cf6770374b3226aff8f86fdd6f5b45c558f275639c8aa02f9b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3c7c002c2e7c25bbc7fee1657dfbbd98048c9b4b2d92947a891f1b4de6f5e1"
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/gcc/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end