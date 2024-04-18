class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https:github.comCastXMLCastXML"
  url "https:github.comCastXMLCastXMLarchiverefstagsv0.6.5.tar.gz"
  sha256 "fea4754bdb1fb4496fec12352e2bd07854843aa757e85d0553f224ff0111c482"
  license "Apache-2.0"
  head "https:github.comCastXMLcastxml.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0cdfed2465c4776d1e7c4ce528aedc9c95dc4ff6b04ad83ec6bd113263e346fa"
    sha256 cellar: :any,                 arm64_ventura:  "28bf7285cffa3b1d27e57ac850e44eb7063133d496669986a6915741540395ad"
    sha256 cellar: :any,                 arm64_monterey: "7198f0a805671f22a82c3270830df3e94f43f7964259f25a0c8c0f8efb0abcf5"
    sha256 cellar: :any,                 sonoma:         "1a669f350a913c7746f8a4368c22725a9a06cbd14f6b81bbb4e675994b73771e"
    sha256 cellar: :any,                 ventura:        "4fd7cd8a2efe96316ab5087992bc92ac2f615d21a4b372cf756daae3e8b117d5"
    sha256 cellar: :any,                 monterey:       "b014a9057d25d860743c59f39bd19731bb1392e4a2fbb362f8c2ff7932b0d9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "168808e3048e84f642d0d04a2fd33d704cb17cc763b5b9b1403930370971d826"
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