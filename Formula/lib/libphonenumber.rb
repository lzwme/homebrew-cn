class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/v8.13.22.tar.gz"
  sha256 "d3594f65d1f1c585bfbeeb5662ef442a4ea2ec4ea2eb3c8e96314f44e06f08ad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "245a9a8b87b359ee38f496ba2c81a0e8c0bc2e2b363a4ad80dce35fc9181db64"
    sha256 cellar: :any,                 arm64_ventura:  "565db72c078edc62473157ae0b09b4d9d7b193d2e0aa3594974a9df4ba579b72"
    sha256 cellar: :any,                 arm64_monterey: "67e62680b40bf4e5946fe8812b796b432c512713b0c68ef1127a4e19d2d0091c"
    sha256 cellar: :any,                 sonoma:         "f95f0cd59a96de8580fae43fb1168107f0532e4d59600f82a6ea61f5f0a8fa83"
    sha256 cellar: :any,                 ventura:        "836acd50e914f139460ca2fa79881525064b300ab422279798b5ef22d7f558e4"
    sha256 cellar: :any,                 monterey:       "cde00e98e33ebbfd713e2b1b8b7b18c95c6cae1903a7bb2c03a96168703c1a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6fb8a6a90a071ceb72db2962fe113e0730084c1b2c31b4dd156cc33bd5f3f76"
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