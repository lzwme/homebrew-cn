class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.45.tar.gz"
  sha256 "831e73649074979847cbd46c78081a8552bd75cdf65e259b426a3247e532b686"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7a1fb97accba2e1cf109a22885f97286a59eb9012d98dc5172c9a8c9921a44b0"
    sha256 cellar: :any,                 arm64_ventura:  "1b7b2baf3d221b718259cb3b1bd8ec79b5238d52feb9585b71b1108216e10bbc"
    sha256 cellar: :any,                 arm64_monterey: "002229b4c17bbaae15aee7c2e4ff264f9ce4f64122c9e06cb8f0a0768b30cce4"
    sha256 cellar: :any,                 sonoma:         "594196674ea46b555c78327231bae5d77424da8d0a8a8f70bb7f6cc776f7884f"
    sha256 cellar: :any,                 ventura:        "03338f8c2a3c3a167dfa60b468b53fc0baceb5822a1cf4bf3be00b24cd05dd7b"
    sha256 cellar: :any,                 monterey:       "2a98939fae17960ce422d3ec70ff9d9f885975b895f0c919116005e5a26acd7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bfab8330627407b0a666454214b06c41872ceb676ff8baa94c64c019f4fc9b8"
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