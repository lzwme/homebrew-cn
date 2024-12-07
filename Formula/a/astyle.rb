class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.5.tar.bz2"
  sha256 "f231cd641047adb6c01adb2511573326a8bb7a293d17b54c770550993deade8b"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fabea697782b1df776c17193cb7ef34a56f068b692c8b149bcf2c324caea1324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "699526de10ed00f5ec226de6442bcab56704f10f619dc1d9c6046f4eec9b0bdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2de51315571ece2aaf331bf2e50981c1b2e15911e5608ff6563aa06040d16819"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc4c710a2922e5737872534ce6176ced701f19c4bab4582879cc3fa6203c6e"
    sha256 cellar: :any_skip_relocation, ventura:       "2bf5256ea8b84828378af01500932c3d2164858dd77950bacb3242bb102a01a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7604d5ec997c131e86a0b72ee50367ecc30c972a9c791cc6f4534a1d640f2cbe"
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
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end