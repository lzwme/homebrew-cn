class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.43.tar.gz"
  sha256 "bf5389a66aa065eac62f1220b2f0f8a9848ba339ea12df3f9357abd9fddcbed0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2a1a2c738677f240c23a34d449bf9ae60d5634496eaaf5053eb678359774efb6"
    sha256 cellar: :any,                 arm64_ventura:  "8e231af083c81cf8cdb725eaec03aea85eb16fc9a6adff788a191186abb13e7d"
    sha256 cellar: :any,                 arm64_monterey: "1b44f321152d7991bc0b96cd20a5715f028a89a4e87506ebd055df34c1e0f019"
    sha256 cellar: :any,                 sonoma:         "e2f8a2005e9658fa833d221c2906e060ccdbc5fdc31f68ba771549341331e226"
    sha256 cellar: :any,                 ventura:        "45a903e0303b116841947f70a0ee96ffd1289e4a8547e13bc079152b1070b560"
    sha256 cellar: :any,                 monterey:       "973fb164d6013e09f430f69190b8a4d5d0836c5b73832c2fb309780008898e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dcd1a6d1fed463693cd063f89e8296fd172f4870296d9169d144ae922d7b885"
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