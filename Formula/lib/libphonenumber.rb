class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/refs/tags/v8.13.25.tar.gz"
  sha256 "229e16404dec98a9b09a368fb7b09e0916b2802e6b9f6428cb0278472245d537"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a4754ecc1857c14154546ba19664cef7865e1cd200fb8587f986427328bf2481"
    sha256 cellar: :any,                 arm64_ventura:  "bb1701178065fafc8fe45f8e52f7847698e9c01b3b599edeb38622abd3d217ea"
    sha256 cellar: :any,                 arm64_monterey: "f24f590b0ddd74eb5c993207c52f86083db0790e77bce4a2f528d5f5a9e2e860"
    sha256 cellar: :any,                 sonoma:         "d5a3d4760b7cf0eb13779ef6d40afec1d06765536438928d77b48497ea283f4f"
    sha256 cellar: :any,                 ventura:        "5e3a3c60428c2eca40ed018068ba3be47a20de1342ad1d531f80a4bf3dd14bed"
    sha256 cellar: :any,                 monterey:       "203992c18f1d1ca84844341b414991af2c22a205332909ce86557609a9b96da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca8c0d5c6b06fb5850de205a83c95f7b455d8e333db3e337d733726d23865f45"
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