class Googletest < Formula
  desc "Google Testing and Mocking Framework"
  homepage "https:github.comgooglegoogletest"
  url "https:github.comgooglegoogletestarchiverefstagsv1.15.0.tar.gz"
  sha256 "7315acb6bf10e99f332c8a43f00d5fbb1ee6ca48c52f6b936991b216c586aaad"
  license "BSD-3-Clause"
  head "https:github.comgooglegoogletest.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "822a712c8de3e5f17af24bda5ad3e8fb6a3a1f187c0084d2f11476164f171d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48f44a5e96d64f4c5bf93debf43be2e199d2ac0c42f1219d758a964e06039071"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0487d09dec338358523895ca6381e20dbb9e54cc391a7e18c07771713ede3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c8519fd4897fdeee9de9df35940b03a51253c4fa61f8309f7894e89e0ee27a5"
    sha256 cellar: :any_skip_relocation, ventura:        "05ae4c495ef577b85e8b3168698e28c0bfdf0e3a83353546f36deae7d5b6a437"
    sha256 cellar: :any_skip_relocation, monterey:       "80e687e7820b901e0e62477af11600daf16b9af64efeb96854c5112176638fd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f03e952765a2426fb76ffe4fa7e61fd312ab9317ea81e36ca2b61e291cce51"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
      "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # for use case like `#include "googletestgoogletestsrcgtest-all.cc"`
    (include"googlemockgooglemocksrc").install Dir["googlemocksrc*"]
    (include"googletestgoogletestsrc").install Dir["googletestsrc*"]
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <string>
      #include <string_view>
      #include <vector>
      #include <gtestgtest.h>
      #include <gtestgtest-death-test.h>
      #include "gmockgmock.h"

      TEST(Simple, Boolean)
      {
        ASSERT_TRUE(true);
      }
      TEST(Simple, Cpp17StringView)
      {
        const char* c = "test";
        std::string s{c};
        std::string_view sv{s};
        std::vector<std::string_view> vsv{sv};
        EXPECT_EQ(sv, s);
        EXPECT_EQ(sv, s.c_str());
        EXPECT_EQ(sv, "test");
        EXPECT_THAT(vsv, testing::ElementsAre("test"));
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-lgtest", "-lgtest_main", "-pthread", "-o", "test"
    system ".test"
  end
end