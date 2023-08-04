class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https://github.com/google/googletest"
  url "https://ghproxy.com/https://github.com/google/googletest/archive/v1.14.0.tar.gz"
  sha256 "8ad598c73ad796e0d8280b082cebd82a630d73e73cd3c70057938a6501bba5d7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15a5ec3a239e915d9ffa09883788291300a8b28c99c6a542f73b0aaae7f7594b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43c6ca8b292fdaad1a8595d7feb628b81f1bd0dc75c13f87375ba870bde7bfad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb8c62a85c6cd68a5a08ff2a57c4ddc4311eebf3f02b749a8dbc92bc29f72c54"
    sha256 cellar: :any_skip_relocation, ventura:        "125c69b7bc9513a2ba5d11734f8c02d4b0a4ac9afd36e6cdb34cfd02cf2c3750"
    sha256 cellar: :any_skip_relocation, monterey:       "e7c803b5bbdced9795b38315652dc5fe0fef945e0cd14eadc9c96acb201c91f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "82bc4dfc2b1148b9ba6ae010859521465bd61cfc90722536f7cdc16121425f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed04c3d4046ec562ed7ff57fe6f58f1e359ac08959849e6656668e7f29a6bbde"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # for use case like `#include "googletest/googletest/src/gtest-all.cc"`
    (include/"googlemock/googlemock/src").install Dir["googlemock/src/*"]
    (include/"googletest/googletest/src").install Dir["googletest/src/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtest/gtest.h>
      #include <gtest/gtest-death-test.h>

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system "./test"
  end
end