class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://ghproxy.com/https://github.com/CastXML/CastXML/archive/v0.6.2.tar.gz"
  sha256 "9bb108de1b3348a257be5b08a9f8418f89fdcd4af2e6ee271d68b0203ac75d5e"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e1ca2f66435c4d1bff7c8346ea94b6b66c8c94858e844b72b8952ed233981c7"
    sha256 cellar: :any,                 arm64_monterey: "84a60af22cd31a13027b28106593273bfefd78e2ef83c57593d9c87de51554a5"
    sha256 cellar: :any,                 arm64_big_sur:  "141bfe75ede4778684f2e39971f52b3282730cd6b139414d8003834f98990b9e"
    sha256 cellar: :any,                 ventura:        "af757918825b0d3b8d7daef7c3631e5a6ebaec3784b2750152a0acb4624415ce"
    sha256 cellar: :any,                 monterey:       "b51edd85a8bb2b34ac0ee3851dbb86962adbace379b8f5c80ce34a0f51a149c0"
    sha256 cellar: :any,                 big_sur:        "72f9c4790de59342cb6d331380d41c1d009318ad40a9beb82e19caab24071830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc8b2583616f8ccde7c0731fb1885090ee86553571ad83cf059adc5189cc8bca"
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
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end