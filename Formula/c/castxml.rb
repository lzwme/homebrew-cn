class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https:github.comCastXMLCastXML"
  url "https:github.comCastXMLCastXMLarchiverefstagsv0.6.7.tar.gz"
  sha256 "faba45ec7e657dc44de39e5640c25354bbe33eaf5d46d65b1094b05586140304"
  license "Apache-2.0"
  head "https:github.comCastXMLcastxml.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e2157090ef153ebeb612ebe30909d78ccf6fdd57bdc0cbc718db69893e7722d7"
    sha256 cellar: :any,                 arm64_ventura:  "0e449f7e991867a261e4b84edaaab1338e55d45157e58bc31268fceb046b3f94"
    sha256 cellar: :any,                 arm64_monterey: "63b828b51d36de56f1beca1df0b183c69a3f3d8aecbe69aa32de4346a427e4df"
    sha256 cellar: :any,                 sonoma:         "a5dc0cc320a6ac58ee5d9f6da6e588d7e57511fef42d5fa452ce88f93d9af2c9"
    sha256 cellar: :any,                 ventura:        "0060357e299f25d8aec3e04f2b7714efda7fe4b7d502a4c1a40cb0f1d8ce2dce"
    sha256 cellar: :any,                 monterey:       "b92510f020e072a1e3f1390c7110e903a25280290a53f575a9c5b8f8d64918ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3b75bdb13b470eaa6acd6af07ef68a71cd9fa27ce340932d496a1f1e7bb4c2"
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