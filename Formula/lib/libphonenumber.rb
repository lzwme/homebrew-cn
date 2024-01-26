class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.28.tar.gz"
  sha256 "1e51a88caf7524d045ed415b6d3a27385efa13d0cb84df935100b51658fc76fd"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67a873b01142032c0019953a6d594ba214ab2901865656793cfa8cd58cfa045d"
    sha256 cellar: :any,                 arm64_ventura:  "c40a385f0d5231fd269cc4d7a6a55391515b1e2a6801fc5a48a2b88ec3717849"
    sha256 cellar: :any,                 arm64_monterey: "3f2f702b76dbc88058ebc7edb100c81546c13fbc21e3a385b7f723d0fce201d6"
    sha256 cellar: :any,                 sonoma:         "b5919453df3ff62a260461321f4a211afede5a84684acee770551efb2aefd096"
    sha256 cellar: :any,                 ventura:        "317fa2d09956302c39348106cd1fa19faa1922a2c95563b5de0eee67de4ee126"
    sha256 cellar: :any,                 monterey:       "a6cac7df5bea036d0da35ef5527ccdb666e12b15bacd8dd375c2809c4f4e751c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19fc128ced01a927078ca28b9e053d286eda148674f15d6ee83210c9e104f16"
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