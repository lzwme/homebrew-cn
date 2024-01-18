class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https:github.comCastXMLCastXML"
  url "https:github.comCastXMLCastXMLarchiverefstagsv0.6.3.tar.gz"
  sha256 "057485afdc8ca0536841cc7b4178a3792ed4dc107be24547dc75b80efc807166"
  license "Apache-2.0"
  head "https:github.comCastXMLcastxml.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa18f48a6454f9cc22d2b42757b5f97605b96469c6de75ca5f74a1a674f56efc"
    sha256 cellar: :any,                 arm64_ventura:  "100e2e3e5ec0ef0c2bbb0e1ebe48ac703f8430cd88da71af5a2a129db382edfc"
    sha256 cellar: :any,                 arm64_monterey: "c09326ecb3beb7a8c58a7d586d788312970acb03b2127603479f4d55b5d69606"
    sha256 cellar: :any,                 sonoma:         "b457e7f082102eb31f40db563dfeaef0537175b74a271b3734fd8ad6533e33df"
    sha256 cellar: :any,                 ventura:        "002f38629c7962d98c6475ddf09f8dd37fbe7d9610e727df279f69d7acbd8291"
    sha256 cellar: :any,                 monterey:       "1e4d0bce14939b64fb05cb8a2bd7946349a23a2aa369517cb613e28ee888a3fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fe58a1955b1a6fd77f383324e5661d7a69252ea7136adf585dd21bbd40377ee"
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