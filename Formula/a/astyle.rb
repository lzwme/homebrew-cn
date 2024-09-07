class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.1.tar.bz2"
  sha256 "5fed6a274b389ba6ca2a291cbbba6b26a31dee081c03fb7d3e34d1521a2b8b52"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "795fb1593bc04854842331639cde051892a0e05c894cd10425f9688692f1c6c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffce84a372fbb35ff730c3f2ab652fc2de80b623d5a1a1e1cd3412ad4e10b8ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0effbdbab68bc4ac131c54700823e8b36e6989473fd6bf23c5bd4e3b9590a9d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8018fe71364398982996eb9e4f0996a9e0e441fb8cc34d06fe10ae7cbc616601"
    sha256 cellar: :any_skip_relocation, ventura:        "ef945650aa4af1612253c0b29f432a09e7079a55baa4fa7bda8b39394752df16"
    sha256 cellar: :any_skip_relocation, monterey:       "a6ef4c80618b0c319804477f4d2931e0581b317d09eb194e204fd88d0cecc7e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6267bdc4b0177458afbd26cf3f5f27f81b3d71f13d36ef7f0f8cc7693a63212"
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