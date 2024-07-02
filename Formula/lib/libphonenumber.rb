class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.40.tar.gz"
  sha256 "0d6733f842c30e5b3762ec1478f1da2f27a7661ae2e6bbe38b8c07ae4dd2277b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1167a841bc88b0d6b7c2c3c15f69ce25b8e9776ad6c845c6ee2e29ca9be68938"
    sha256 cellar: :any,                 arm64_ventura:  "13e5b0259bce3732f0c4d6e6bcca5936a86ffe895a0b9ed5d7d2173e0faf4d51"
    sha256 cellar: :any,                 arm64_monterey: "db893a33f8975c84dd069cb2dedb688381c47591fc89f4a646171a8e56feeb12"
    sha256 cellar: :any,                 sonoma:         "42fed5a402cd755aaa1f512352076d113ec2d6b76840be37b9ea976b0059dcf9"
    sha256 cellar: :any,                 ventura:        "0a44baabfb442140b03f9bbb6c58fc43fa98cbc1011eace05f96efed5eecd86f"
    sha256 cellar: :any,                 monterey:       "bb65648baa816388b557bfdafce51809ee325875e6b86e3d66dc32218789aebd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbe14dd037616bec7624a4b81668e1332762f7a3ffa794ff6d4ae93e8ffd42ee"
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
    (testpath"test.cpp").write <<~EOS
      #include <phonenumbersphonenumberutil.h>
      #include <phonenumbersphonenumber.pb.h>
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
    system ".test"
  end
end