class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.10.tar.bz2"
  sha256 "6f67ec872b437bd3c51e0f75e112e4dbfdb26d5fb7bd9cf8a480f10af5557063"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72c106d56e1e56ca5d7c33c53e6b35a4ec08c1d7b25dd148bb12b2917d5e4e5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b6f7a61794697c110a0c4109f6a19df5ad1a1ec77d53a3e506ab8362832cc34"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a43cc61de29b31f03ac56383eabd74ea8d7f56e3c3ae6aa65de378dd4ced2faf"
    sha256 cellar: :any_skip_relocation, sonoma:         "7afd44677067374ed17ca89c4988db9cb586680039fe0ed31a8c297a9f328bdf"
    sha256 cellar: :any_skip_relocation, ventura:        "86f37e989d10c9b3ee039713d111307ce2be66e941cb421c8ac68955a3e761d3"
    sha256 cellar: :any_skip_relocation, monterey:       "c99a60fddb983664f8b2e1a9d626f648dee0284c6c434d3ae82ee27b4f060552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cef79268f325bb1a681b73fa79a596afc45349cceb3dd939008517f3eafe4b6"
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