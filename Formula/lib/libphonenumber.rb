class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.48.tar.gz"
  sha256 "71bd662c7fc9e6e0275412529a28e1da464afab3dbee4387089ad8f88f96ae59"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d60363e0adfb4fb0a80f6709b54ce570d6cfd8f990bf8e314979f31c52264811"
    sha256 cellar: :any,                 arm64_sonoma:  "26e2c1e5ab7cd49035418257d7546167c958107140d7a6fba1e559d886bee4aa"
    sha256 cellar: :any,                 arm64_ventura: "cbd95dd7dae4fbdd58445e4c9e3c779a85783fab9f1ea6b9f039cfe07ca4fdab"
    sha256 cellar: :any,                 sonoma:        "4055afb21a91b8b36fef2ca47d72564fb5ef94aa40ab92609cc4ce8826ff8c9c"
    sha256 cellar: :any,                 ventura:       "8fdf1fb93ac73d3abf7d8987f87d519fa14bcd000af50e3bbb96959268e2fa44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b21b7142d6937fad5fe3fd193d96d879ed1afa8cc2100462d6a24a6e481dc2b"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@75"
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