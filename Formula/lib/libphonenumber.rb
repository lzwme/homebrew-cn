class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.37.tar.gz"
  sha256 "350f99f5eb99c3220388019533b28f3f6e4ed1bbcffb64abdcaed43cae6b0d21"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bdd6176e99e4c912ec26f9c79e9f5b38f2d8490cb36d04a49c64fc2c1c6c2266"
    sha256 cellar: :any,                 arm64_ventura:  "58c6c37d76994ac1aeb1bd39c316e5d5c133369fd6c868dd3647a310c3cb6831"
    sha256 cellar: :any,                 arm64_monterey: "218f6595df562f6e7a4229daed419b67f5634dffa9a430f7b04d5fedf0dc4157"
    sha256 cellar: :any,                 sonoma:         "10eb4f4bdf7de60d616608ca57aa06c6d93818e64f375becd50e26da37e6ce4e"
    sha256 cellar: :any,                 ventura:        "7c3a60dd9afefb8e50a08dded69ac92a9f7ac74b0f029e9bab7d7a46e6533fc2"
    sha256 cellar: :any,                 monterey:       "7ccb5c0d6e4436abcf2390b3bb4f57572e152259df6e2c0629e81d539fa65b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19cab05918ffdffee77e8c4ee35ac29ded33b32776a4f9eb45b4b4ba50130990"
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