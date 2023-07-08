class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/v8.13.15.tar.gz"
  sha256 "ac7082eb679d1b68f4877a8f9407c9a729aa3eef0e018b3e95dbbb10d7a69e29"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "465ea49397c4c4815020a5c283c1f641f378a507d736de56ef778cb2d0d695fa"
    sha256 cellar: :any,                 arm64_monterey: "141ff4c3521fb762df752b4026373342466730ffeae9e66e79926801896f18dd"
    sha256 cellar: :any,                 arm64_big_sur:  "66b2e1c05609bc53b6e7c96a8f8af9007bddef964866d6b361f5b0f0f762b762"
    sha256 cellar: :any,                 ventura:        "7e46a08a5fcb2be67a9b968b56eb36e2477dad557de88085e6eda78f6f583aff"
    sha256 cellar: :any,                 monterey:       "1483ffb0564d5a68641d091959f91810c45addd5c5ca7cf2f410b1dac45e3ed9"
    sha256 cellar: :any,                 big_sur:        "61fd1ab9753142711d11c80193b555e056102afe1f2303606ae254b587de0c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e84fe1ca8915892e3a7b844412cca315ef0374443ae07358be4420daf40fb35"
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