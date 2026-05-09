class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.15.tar.bz2"
  sha256 "5b4077d68b5941608916cd8a263046a3561f97593703c04831c730b230a81ae9"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bed84875e13c2e56b9ca669d59512586bbc324264df80c16a5dbe40ae500952d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e288ea3c6030383564c8fd6645286005082acb8895f8edc9dba4fa115630975a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e915770bd4062f39b300a2f2bb2bf99f0a01b62bcd14bbba3517e76fdaa8926e"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdf342f0a349276e009f47f505d112032febf1c09d594e4f1d18eff7cedfe183"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5759125cbdefc6740bf4d94d2a03dc702f5235ede689dc290c2fbb55063b7c6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9421978825594de75817946591133ed97db6cd311356834ecd94869823e274"
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
           "--lineend=linux", testpath/"test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end