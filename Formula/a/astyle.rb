class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.16.tar.bz2"
  sha256 "cb760434f7e4624d5eeb2776ac334e79e01119bea419fc986edd2c24d9380364"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c67d974709dd9e701497470dbe203a068fbdf41c129b837d8476e8662912094c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f46050fec345b228aa188adb18f46c982c4cf987e9e961a855898415cda4898"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c1052c2566abe4311fbe3ee9f6d8bd0a658b8dcc14e82456260f43181a06b06"
    sha256 cellar: :any_skip_relocation, sonoma:         "1366d7ea10b2e2a0cf67a80558a7d21630a79353b9adafe2acbb5b1de0499c22"
    sha256 cellar: :any_skip_relocation, ventura:        "1ce5968a42beb480851c5575153227f348941eccb48e6ebdd87e28eea79d0371"
    sha256 cellar: :any_skip_relocation, monterey:       "c3da4d073f208e82fde33b18be2fe1f52a172461709b75c78f8f838570fa45b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "365f01cbb3fb256be7f005ab39f844570cd3e95696a6cc216b60d6f8bddaebcf"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
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