class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.35.tar.gz"
  sha256 "dc3dc9aaa48510f424f8b9ec520c0451a7dafdc46c800d1ba3701f82e6dab078"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e36c41fc4d1bea2d7b4053dcbf8398eb0b37aecbb22a9048caaf5687b8ebf008"
    sha256 cellar: :any,                 arm64_ventura:  "dfea61a757f7b2a8df4784d85bef59c778be92daef5829da3db0785375b69aab"
    sha256 cellar: :any,                 arm64_monterey: "859be1a770cedfed1a8c59127d8ba1dc6f1a4d2d2f321bc48a7bab0974f79b89"
    sha256 cellar: :any,                 sonoma:         "41de0e564af1377cdcee0b3e98aaf15ecf031bee66955c36557e6892431cf5a8"
    sha256 cellar: :any,                 ventura:        "391b05a5ff5b080fc0028f4596869809e0a85191e93d85e391c0c364e6c70e66"
    sha256 cellar: :any,                 monterey:       "afcb4f5b30cf5dd2f86df870e3cb4ed33d5c1ff374e3edf071072a7919e4c4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98da92631149470a3472985fb8a912bd14ba79aa075f66aa7165e9d5fefc18a7"
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