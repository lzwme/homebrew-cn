class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.42.tar.gz"
  sha256 "7fac3a3c5f37607108ea2ca4c334000a6c29fe1cd6b30db31505cba73ab96c7d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "509f0a734f6e76f64169e7e7953eaa7bf153b424ed55d2c205fb25c1eb8311eb"
    sha256 cellar: :any,                 arm64_ventura:  "28072e21221e7a61710d63f5dba10858bfc429f97c8c286cbd159a338f5f794f"
    sha256 cellar: :any,                 arm64_monterey: "a570565d841a8ff50b7c32b9927adf14690c7f873046c0edeaefe77f6471ad4a"
    sha256 cellar: :any,                 sonoma:         "45e7a9eb104753bc3f8648edfa94dc644fd4f09a6b54bc09885dcbb7ab95f729"
    sha256 cellar: :any,                 ventura:        "9325d71ef511b371eeb4faf1b85f5d4e675f2d22dfe6aca586bb97782ef2b1d5"
    sha256 cellar: :any,                 monterey:       "a3688c78f4fc16b6ed0b4489ea748520287a7ec01be343438422bf2eaf9d4ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ca84ce972db70db110ad080ba3438f2fc327ceca96a2144fe2f9d0395895ca"
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