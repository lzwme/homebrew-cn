class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/v8.13.19.tar.gz"
  sha256 "2dc0bff42ef15d020ca2ff2e25828443c92c870e224a877e9154622b97d0bac7"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c65ab0745dda13ef959c6245dcc10f66c5bec194d0e8f1c55d5f04789a078f3"
    sha256 cellar: :any,                 arm64_monterey: "ca933abfd573c0d3eb1885e5e87cf15ca7593e378db92eb54d2a08b3d86ecdcc"
    sha256 cellar: :any,                 arm64_big_sur:  "d5d46e829772f44bd9ae2b2684aea43f44c72647aaf9cabd3a204fe93e423f6d"
    sha256 cellar: :any,                 ventura:        "cb2908a275631f088b05c683f386d4838b973a84fdee21d00148bbc42f6cee02"
    sha256 cellar: :any,                 monterey:       "c2b0951719e111b87d5665d67a3e9d935ebb027511b5b494ab4cd43ff9e3347a"
    sha256 cellar: :any,                 big_sur:        "322ca0cb12cdcac7a199228fbb97e9a40c9ad57ff18a9fcde900fb7ae3ba27ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d50bb191668ab77a6802f3b5e78cd46c9398f2a1330188e68b2e7199d04c33ca"
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