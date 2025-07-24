class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.11.tar.bz2"
  sha256 "0eabee3fd9d07406772abce93241d62c1f47d456d3f941cbf15af9c23dc74ad6"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21534007db713d28e56aa5dba329173be4a23be4b9968979da151f9b32aaf090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14273995c89731defd99e5d903a44838f5f68bedb1e6611d060166e301e71dbe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7838dc17729b670e5f73b95590d38b362b1a0b86708727a9f60e8a500dfc1776"
    sha256 cellar: :any_skip_relocation, sonoma:        "9683d10172078ecd2eadf0eac1edf1ee1dffe730d7c698ed2e80e1230f10b593"
    sha256 cellar: :any_skip_relocation, ventura:       "d238cc82657b4983548a2a9b70192eb204db32debad0bb267f5c56846276c26f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e346ed219cf27c3aaac29779ddbcaa5f183e59b1ed5398fbfc799e01d7212a62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d772b79971f50ae8b9f7cd2a8362aa2118ef5ce6caac0036c15caee77e9dc002"
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