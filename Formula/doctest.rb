class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/doctest/doctest"
  url "https://ghproxy.com/https://github.com/doctest/doctest/archive/v2.4.10.tar.gz"
  sha256 "d23213c415152d7aa4de99bb7c817fa29c0c03bd1a89972748579a7217fdbb8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5b9c1591eb8725eaf6aaa851f094a1f6ed90fee952f38e48134d230ca4582672"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end