class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.7.tar.bz2"
  sha256 "ac30a043ece5920e521c2560055877251bfeb8e102c589c65c50550f1eb25cef"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c205e35e92d21512ef08e4e1d040cd8a9c0ad2009e7a30f8fcc232db5d9f6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4e00e04e5ac0be9b989133199c8f0e3eed1cc2ae885313dc2c4d1f5ef8b3955"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e6b9615ffbe17a364bf81644cacc232b301896646290dbdb12fd8c31d53face"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cbac5dca20d99c055efa26d8af02342ad74f040834cc0daa01abe22f89a3427"
    sha256 cellar: :any_skip_relocation, ventura:       "551b85af70234961eabb2d76c002791a7af3468ff4f6ea0e4dfba1a38389976f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5ee07b238286432447e0f576db80782e2ea0d15e5515ac462b15d9467a56c4"
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