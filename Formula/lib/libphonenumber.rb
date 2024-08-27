class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.44.tar.gz"
  sha256 "ef97fb52384e1dcb25bbb26ea4c598962efea6400acf857a38287a3e4ff72690"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "de04868b203fe5c2641efca3f7293557be9d9728cef1b75b59c1537327aeb9ad"
    sha256 cellar: :any,                 arm64_ventura:  "38b12ed21a76927626465f734f30ed38ad700ed12bd14c0bbe9304c9d0c70d18"
    sha256 cellar: :any,                 arm64_monterey: "54f352d91e7c35b32f298c75f74e54b69bed4090194d53dd7f521aa6cc584969"
    sha256 cellar: :any,                 sonoma:         "65ab7f6c05c44ad09b578f6e71a45aed8f027ba2ff8b7ea476495724e9fc155e"
    sha256 cellar: :any,                 ventura:        "ffa3d91777949bd6149cf06348717ad4e5a90b4eea79c7f428ab8af2aefb696b"
    sha256 cellar: :any,                 monterey:       "ac454d331b5de9146fcd90db7b417c415a57fd3019922c2e30fe82ce09fd60a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77439e54cf22087925f3c1dcc3e000962aea7339b2f7682a654bfba9c9a91058"
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