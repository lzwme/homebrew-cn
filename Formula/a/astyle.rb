class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.2.tar.bz2"
  sha256 "f7e8e1ac4aa314a6645fa7016d882da381a8e1020c83462a2ca26cb25d8f3cbb"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed781ce723abfeb78d363a125024a8feb42c8ff753680c128bb19b3b004239e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28fdab307ff15f08fa7974be9b96d6468513d8ba155e268310546a03fa3f35a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cc94cb50944600554149d9eea162f4f69e581440b269548519b0181f2e03c03"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf41c7fac4c187d8cbcf6809ec48dac025d3da1119d4b3404c9d079d6544bc9d"
    sha256 cellar: :any_skip_relocation, ventura:        "657ee1deda8b7edfed3b2839e6253cbbd07a73b368702c96545cb5f22e933623"
    sha256 cellar: :any_skip_relocation, monterey:       "b9cb9bde8b99a290e870e05392e081cdff26fcaf9ac55151ae79a0511d3fdd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09006c65f29de4f9fa6800b54b74c679ca3c30770138cd1b6f945f7d55a2e15e"
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
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end