class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.5/astyle-3.5.1.tar.bz2"
  sha256 "747a1595cbd9797dbeaf84a02836941ce88d62948d3051bf58d74be0dd74a234"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab7b0bac048f5253f577c687e38e3c3d524e38b2e1e107697183a0a9bef883f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "add5a3eddf587c65c4f0cb49e1ecd9f820e9deba962db7be56d476bf935a5456"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6eac6fe8d0cd4c502b9bf05a233af9a616a7cd1b901e63f093c85398faf6e80"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7831ebdc1ddc1eea94bc3af65ff7c6dc9bbdfdc534ba72a632376692991fe0b"
    sha256 cellar: :any_skip_relocation, ventura:        "f3f0e84779a23986f1cf50a07a5596d16ee6bcc0194699e5b1c5df345ce44ca5"
    sha256 cellar: :any_skip_relocation, monterey:       "ae611f25ead4643cd9f385c6b39a4d1301943109cd7e4452d13e65e1eb9013e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5c91ce5153baf8d31ba6a0380b9ea4f5f144c176ec70aad629b43b95bc529b0"
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