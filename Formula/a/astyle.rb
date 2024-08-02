class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.5/astyle-3.5.2.tar.bz2"
  sha256 "db0c0a72d40e640c201e39e64678b6fe316f37e7ef05f67ce2b22d555c0a6d12"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "693c64486b8c9a96d0dad168ec31dd72c6d7ae80167af0bada17ca661a99e027"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c3f9b6e527cbdbc6fce3de401236fa297fea54d91ba0787cab809da4e1a8ef7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8720696accd267cecadc553b9d36a967659129e049448bd7b6234ab27b6e7a36"
    sha256 cellar: :any_skip_relocation, sonoma:         "62ca2346bf659434aecf685ae03a709811169d45561e0aee5aaa7a558350e435"
    sha256 cellar: :any_skip_relocation, ventura:        "0471be5fc2083e30ef70049c0a496166bfd665d3d5e5d1a8248776931a78f76b"
    sha256 cellar: :any_skip_relocation, monterey:       "035679ac605ae157e6a3bce9796d37e823d33d2087593dc5c30ad0641825cd4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d43b433f276042904b3a88a5e5434d252ceeef603ab5bf98632c02eb46b2a653"
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