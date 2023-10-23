class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/v8.13.23.tar.gz"
  sha256 "fcfeece0ffc44b1047228b8a24be9240023f4c9105e4e88b4648978764dad9a9"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0610dc2e957dc9211db2839b68b54f0bcc97c760249c8f2d1f4b9b997f3e81b2"
    sha256 cellar: :any,                 arm64_ventura:  "5273b2146b9e47ed439eadc9afba34dd89e31e1f8aefa6cd89d49c3dba35fb4c"
    sha256 cellar: :any,                 arm64_monterey: "6beec1be2d87f44677d32bdfe77d3ca6ce5da8c0f0ace7c1e33b1f783a719cec"
    sha256 cellar: :any,                 sonoma:         "22e6bae0c54d609d13f9c508eb3d626a4823f0e752a9fd8b4239555a4afa7f65"
    sha256 cellar: :any,                 ventura:        "649a91995472b0764cca67d4cebab913340a61facd5eb2c81f43bf06a8b81aff"
    sha256 cellar: :any,                 monterey:       "99bdfeda3f0d167f40009d256d531d5dd6c96ad0bcaf67138f1a7a879b6661cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d556acfbb7e8f7b85c25f3de386413ea7ff5ba4d7402e67764e7f67f4aeaaf54"
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