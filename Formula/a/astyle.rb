class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.10.tar.bz2"
  sha256 "1d6ee89c084a93ddcc28d1a056cda8d1c357d318ef8e284456d9f0bd2ceb4b6d"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f02b3466190d61ce7b5f16a6abd545aa9e691265630a0689b7e2939ef39fdbc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2835fa0237115250cca426ed170b2cf9c395f1698a77b33c419f95ecb8e6f41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a75ba0ee3ec93da5614a5693dcb4e88efedfc45c34e3c2d7b344f7684fe847f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6941aa3c5ac7d26126a6a5aeefd1f385b69666978e9a91f32d8d2a09aade7726"
    sha256 cellar: :any_skip_relocation, ventura:       "e24c91c642cc0c681ab05adc4cc558c520fcb9066930b9433d1aa262fa506ca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a20db951fbd59f29f0e38e508351cebc1520ea5e5b4906ac3d8733ea26f38a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5dcceff69c5143c6f3e1c0ddb8995219092c34ffefa2e9f92ffb6a8e45ddf29"
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