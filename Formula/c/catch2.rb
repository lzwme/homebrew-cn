class Catch2 < Formula
  desc "Modern, C++-native, test framework"
  homepage "https://github.com/catchorg/Catch2"
  url "https://ghfast.top/https://github.com/catchorg/Catch2/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "a215c2a723bd7483efd236dc86066842a389cb4e344c61119c978acdf24d39be"
  license "BSL-1.0"
  head "https://github.com/catchorg/Catch2.git", branch: "devel"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e5aeb0735c601b4363ae5a678812c8d23593607901e4801dcaa7233c8c5a76e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15427b27d8441ce8eefc55cf9861f89cfccb967f6d18781a75c965974922b167"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e710fe128376275f1b8623b0a129fd1a0e4ce66fc57c6beb17ffbbfa10f34fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4202d78e41cbdaf55844e7fb876e762b23704c35beead0441c13ae67b2657de"
    sha256 cellar: :any_skip_relocation, ventura:       "95c992ef3c05280e6c3eb24505697b053119cae4aca07ec55373e77f27f913e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c531c038f13650782e67756883b45be0c64391b819dfa114b3ccbcfbb35c8233"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82422f03280f9dfa7258acb53ab8cfbe8dcdfa1c1a844d8d080c3794d30a26a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <catch2/catch_all.hpp>
      TEST_CASE("Basic", "[catch2]") {
        int x = 1;
        SECTION("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SECTION("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lCatch2Main", "-lCatch2", "-o", "test"
    system "./test"
  end
end