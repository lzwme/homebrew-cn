class Kfr < Formula
  desc "Fast, modern C++ DSP framework"
  homepage "https://www.kfrlib.com/"
  url "https://ghfast.top/https://github.com/kfrlib/kfr/archive/refs/tags/6.3.0.tar.gz"
  sha256 "3b2eb54edb9c1ba6d30648b47d11bd445cda4883052d592801bd5482f837162c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f55aaba2eab81cb37a798078dd940d89590c15327473edef5abdfa28f32af62c"
    sha256 cellar: :any,                 arm64_sonoma:  "34b3de4092d55c946029829a8c923ed7fe893e0f2e8e18050bb2fd2a57566900"
    sha256 cellar: :any,                 arm64_ventura: "65bdd9219429167fc07d9c974d88e7faeb22af98878c69e28ffb631bbbd757db"
    sha256 cellar: :any,                 sonoma:        "935b85e599083ab9cddc5bb831f2fa976da58b6e3e19e583b6419fde3adbae49"
    sha256 cellar: :any,                 ventura:       "5dc75948e82a91673d319c707a3a7812cc1b8a3308cfd99140bb6196e23d0184"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19670895a52cce3460bf091022db24b08b133a69d7d7991bb4b5090cc60716b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db226859f3d46b4836341f1a479d3cc4cf7a0275b9960f6cc116643d587a9151"
  end

  depends_on "cmake" => :build

  on_arm do
    # FIXME: `uses_from_macos` is not allowed in `on_arm` block
    on_linux do
      depends_on "llvm"
    end

    fails_with :gcc do
      cause "ARM builds require Clang compiler"
    end
  end

  def install
    args = []
    # C API requires some clang extensions.
    args << "-DKFR_ENABLE_CAPI_BUILD=ON" if ENV.compiler == :clang

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kfr/io.hpp>

      using namespace kfr;

      int main() {
        println("Hello KFR!");
        return 0;
      }
    CPP

    ENV.clang if OS.linux? && Hardware::CPU.arm?
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lkfr_io",
                    "-o", "test"
    assert_equal "Hello KFR!", shell_output("./test").chomp
  end
end