class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.42.tar.gz"
  sha256 "7fac3a3c5f37607108ea2ca4c334000a6c29fe1cd6b30db31505cba73ab96c7d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "335b59923c716d796b283a840c58296519ee25b1563b3b841dbee15a93bf0fd6"
    sha256 cellar: :any,                 arm64_ventura:  "6f8fa471c701e56c8d2f434087185ac4cdc545e6d65c25c38822f4608313e14a"
    sha256 cellar: :any,                 arm64_monterey: "3edc3946b62ab3964f5cb152be53b8e40ec795f4c03914ea34b8910ab715d4d2"
    sha256 cellar: :any,                 sonoma:         "64c97626b614f0f87b0acc677f44045e7e35e7ae5e4cc81f03be877b6aaeb379"
    sha256 cellar: :any,                 ventura:        "0a6c641639ac1f29aab6d941fa5f886606886996110d814db750451d7a8dc667"
    sha256 cellar: :any,                 monterey:       "d2b1af43214aacbdb3896154b218e1023ffb35d9b737c13dcc946e582da72ded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "febc2d49dcd7ae010bdb1f3c7d70b72d32c640c3d9876fd6844fb7ec49413f8b"
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