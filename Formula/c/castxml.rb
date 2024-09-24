class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https:github.comCastXMLCastXML"
  url "https:github.comCastXMLCastXMLarchiverefstagsv0.6.8.tar.gz"
  sha256 "b517a9d18ddb7f71b3b053af61fc393dd81f17911e6c6d53a85f3f523ba8ad64"
  license "Apache-2.0"
  revision 1
  head "https:github.comCastXMLcastxml.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c3e6096ebeb212633387dfb4079e70693de0ed8fe2e8716472aafff37893fdf9"
    sha256 cellar: :any,                 arm64_sonoma:  "64879e3d57f14f5d78eff1825bc615c3cf528d0252e358c5b9c9c63bc0425989"
    sha256 cellar: :any,                 arm64_ventura: "3da47ccd6c2df92725b72f393a4497b0856bc6a2245ddaaecb22393c46aba3b9"
    sha256 cellar: :any,                 sonoma:        "68bcb12975621cd10264a035306e402260f707a0ad409f25600f19c4bfab1234"
    sha256 cellar: :any,                 ventura:       "caf54e3bde83c17344c9ebd6780959c241c3096152ecd0cbc62b553cd2f0bde3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497247f119be0b5baa9940d48e25ecc0b20af5f8e04a7d3cfe64e27e5cdaf3a0"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end