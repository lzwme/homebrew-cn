class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.29.tar.gz"
  sha256 "3490c4d9643c1ab279781b5b9d8b0e9d78d8b492394769434a74a3d5862a8d11"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bba68aef4aef109ae819f3fdbcff584f78ef32c0b45d5a383e80e175dcbc2fb8"
    sha256 cellar: :any,                 arm64_ventura:  "24a27c50590dc68bae083828013e4d50240cc3dd97f8b9d385bff25c140fb891"
    sha256 cellar: :any,                 arm64_monterey: "ac4794565978ec7b5edeb682912cc9c9d87a440e3260162c9ceedfea1d2cc352"
    sha256 cellar: :any,                 sonoma:         "fefa019f6cc8a10f251f145d15b32dbd3ece12cc745d2ae32a40604c87e34df1"
    sha256 cellar: :any,                 ventura:        "1e0a6792972bf5fe51e288e509d8685fcf1aba0e63e9767151039f68ecbfe338"
    sha256 cellar: :any,                 monterey:       "97fedf77aa829beee48242a8c8fd6274a52dd7a7c5dceb60465eb28bc56c380b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4339b08b3160eca2f2a020990cd1636749ecdacad116b07d3be69cb52e947419"
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