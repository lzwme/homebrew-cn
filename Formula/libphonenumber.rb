class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/v8.13.13.tar.gz"
  sha256 "5722d25b41ef621849f765121233dcedeb4bca7df87355a21053f893ba7a9a69"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b294944a5b2430474328e0ffa37218643ec3c0fc451fe5e74147c338869e4b2a"
    sha256 cellar: :any,                 arm64_monterey: "6b3987fe58a8abcc887b3a78eff60ccb2152931f59dd62cdfe08543f97be8dac"
    sha256 cellar: :any,                 arm64_big_sur:  "4eee5a71fdf7fe11ebc6738f837a5dcaaca701ad9e84f37167097b45755f647e"
    sha256 cellar: :any,                 ventura:        "f37c6dbde556677478a4623427fa0932b4ec7d0b7735ebde793cf2f56b2bc28a"
    sha256 cellar: :any,                 monterey:       "56946c9807f5418240c1cb6c2f5e8522bba8beb8421f5bf0e0cd35dbf6bbccd5"
    sha256 cellar: :any,                 big_sur:        "aa30b926630fe02b83a311763df5d77eef79d7a7beb1e7c70809033ae2e63f7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1082f9a98ebc7606635480071a6325cd56c26805926a6754c2292d92370f67fb"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  patch :DATA

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/cpp/CMakeLists.txt b/cpp/CMakeLists.txt
index d2d111d..5b7d2b2 100644
--- a/cpp/CMakeLists.txt
+++ b/cpp/CMakeLists.txt
@@ -19,8 +19,8 @@ cmake_minimum_required (VERSION 3.11)
 project (libphonenumber VERSION 8.13.0)

 # Pick the C++ standard to compile with.
-# Abseil currently supports C++11, C++14, and C++17.
-set(CMAKE_CXX_STANDARD 11 CACHE STRING "C++ standard used to compile this project")
+# Abseil currently supports C++14, and C++17.
+set(CMAKE_CXX_STANDARD 17 CACHE STRING "C++ standard used to compile this project")
 set(CMAKE_CXX_STANDARD_REQUIRED ON)
 set(CMAKE_POSITION_INDEPENDENT_CODE TRUE)

diff --git a/tools/cpp/CMakeLists.txt b/tools/cpp/CMakeLists.txt
index 91c9052..ae8db75 100644
--- a/tools/cpp/CMakeLists.txt
+++ b/tools/cpp/CMakeLists.txt
@@ -17,8 +17,8 @@
 cmake_minimum_required (VERSION 3.11)

 # Pick the C++ standard to compile with.
-# Abseil currently supports C++11, C++14, and C++17.
-set(CMAKE_CXX_STANDARD 11)
+# Abseil currently supports C++14, and C++17.
+set(CMAKE_CXX_STANDARD 17)
 set(CMAKE_CXX_STANDARD_REQUIRED ON)

 project (generate_geocoding_data)