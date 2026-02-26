class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://ghfast.top/https://github.com/CastXML/CastXML/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e70728229db5444384befcba9681a01497e9a19e35166ce1ffef3b5cbc8eeefe"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dce0af8f585d2cc97ef508c57fd18cf4c00d1d9e19894457d1478b6bb741fdfd"
    sha256 cellar: :any,                 arm64_sequoia: "9869697d0cbea10bdf78ad3e290178440a658a268954cecfa08ef6fda495abbc"
    sha256 cellar: :any,                 arm64_sonoma:  "9dbc31b5c402154b99292d7f88b21dcc925ccc1df8535cf3e383aa7e1959da02"
    sha256 cellar: :any,                 sonoma:        "82d0d69a469719b11af1e976ff2af54edf905e857e9a94c4e14b74b25678038b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "215d8696dd357b081ef91688970d8f0bbc7e60c0d4cdb53096e3226ca718562f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36c58b5a2e635efd7e7a57673550a936682e6e434ba7a36c78882915f477866f"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        return 0;
      }
    CPP
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end