class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/refs/tags/v8.13.25.tar.gz"
  sha256 "229e16404dec98a9b09a368fb7b09e0916b2802e6b9f6428cb0278472245d537"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2594ac2911b84f5154e5cfa64d2006ea34b5b8fe89079e7c620a06d0e26491a9"
    sha256 cellar: :any,                 arm64_ventura:  "954d3f60be0bfc164d3907a2a5eb725a74606d837168139a2b3c5b8f1c63d9eb"
    sha256 cellar: :any,                 arm64_monterey: "df8b128bef57179203869a86c15bccfd6ff4aef113ffab23743ec8a06ab1bde8"
    sha256 cellar: :any,                 sonoma:         "43439f0ad6ddef4ff8d8651b3d4e263eb5f70744a17c79536bfb741d30facb68"
    sha256 cellar: :any,                 ventura:        "32304e07b610be73bbb31f7044ab14c82e4c57df141221062b59b09d7beda412"
    sha256 cellar: :any,                 monterey:       "bb919040bb5e8e162bf19467025afb177cc4e03b6309c1779891668ee54c75ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "decf79545d3f15f769ea8ab6052dda8534ff807e30466489a0b05c1fb3743c04"
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