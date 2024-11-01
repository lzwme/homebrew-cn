class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.48.tar.gz"
  sha256 "71bd662c7fc9e6e0275412529a28e1da464afab3dbee4387089ad8f88f96ae59"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "38ef9cee23d2d79e921798b69659a05c64d160bc3056950d73f0da611b4b1539"
    sha256 cellar: :any,                 arm64_sonoma:  "2df987eaa15935f4d7e4f3a9cc05021d6ee85a3df91a0e9d1b8514fde662874b"
    sha256 cellar: :any,                 arm64_ventura: "ba10f398fc5d923ee0c62dc5dce3e634e09c4f92fc4409ec72ef8aa872ab7af0"
    sha256 cellar: :any,                 sonoma:        "f6ede1871a2efe7f8a588e43ac740d4329bd100aaa3072cc220809aa4a73768f"
    sha256 cellar: :any,                 ventura:       "7ee52c97febf86bcd4118d1033bff32c375ed4ca3cd2c02a95ed03ec0bd31eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03d2b27d569032ef54dad037b6d3e565a56c9990e69e136d4518f8eb927e081c"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <phonenumbersphonenumberutil.h>
      #include <phonenumbersphonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        std::string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp",
                                "-I#{Formula["protobuf"].opt_include}",
                                "-L#{lib}", "-lphonenumber", "-o", "test"
    system ".test"
  end
end