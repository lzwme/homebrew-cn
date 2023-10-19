class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.9.tar.bz2"
  sha256 "44239275c70eda6591471129962cc03d19eba41b15cb194590971c3b4a2de18d"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfecf6cc5ac3aa3cb48bedb6990f11a2cdeda55b00fcb509096ae375579b44a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8aab30fe0d12440995f57a0332403913d6c9e61f1559530bc2261860e8d6551b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a64db68e88399831fdcbc086af587f8ae7c9fc55b7dc71ec10202428f3e1702"
    sha256 cellar: :any_skip_relocation, sonoma:         "5651acdc2f68649ab4308405a270b8b1cc4cde3c938f16089c8febdde98b222d"
    sha256 cellar: :any_skip_relocation, ventura:        "a1d5111b26f588e9863b3b5165ef09b7490d8a65b538d10ee807d22d7c26f807"
    sha256 cellar: :any_skip_relocation, monterey:       "cdaaba25df9b780ceea18ab62edd6b86d38aa16ab940f2dd6ecd0e98213d91a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bd80894986c46848b68b580e7f16513b060e0441132ec2250879f09f246dfd9"
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