class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.28.tar.gz"
  sha256 "1e51a88caf7524d045ed415b6d3a27385efa13d0cb84df935100b51658fc76fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e8e4ccedb138db975470efe205e68fdbcaf55fe55c1f6ffd7d0ce1cab29c71e6"
    sha256 cellar: :any,                 arm64_ventura:  "d73abfd5b7c504bc2121a321b3f118e625bd4e5f78c511aa4b42ec3db2d67bbd"
    sha256 cellar: :any,                 arm64_monterey: "79009165b92e5db1bcdcad09f506012026bf98fe437543695d70fa0cb1bee90c"
    sha256 cellar: :any,                 sonoma:         "d9faa1fad57d16e9bafe321f19052dbdf93910de2371b17bcb99be3bed18a2be"
    sha256 cellar: :any,                 ventura:        "b62ed0fb600fe0c64bb186b0611846f884ab957efbb818e24f474dc47f7c82ff"
    sha256 cellar: :any,                 monterey:       "b4b5ad77ddf7177be2e199bea70d7747b7fb5f322b2917c56f7f28b5ed8e7da3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e2bb540c0501b974347a9a86b8fda0ce0401b0828b0ab11caa1f4d7893c883"
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