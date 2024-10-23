class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.48.tar.gz"
  sha256 "71bd662c7fc9e6e0275412529a28e1da464afab3dbee4387089ad8f88f96ae59"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6091b1275a057e97c0b6dabb267f708b23a982db4e819b313dab2c0124185e24"
    sha256 cellar: :any,                 arm64_sonoma:  "c44320a397ad8a0ae2883fa9208166af0f3189177bf4a5b4f5facf5fab328398"
    sha256 cellar: :any,                 arm64_ventura: "734bfe8c44e06b04132019dba5a1ab5691cb99c3ca67a46711c28a1c2d6dad84"
    sha256 cellar: :any,                 sonoma:        "79f7d7c4e18f859a21f76d516a3a001e0dbd1f1bceccbf10675d76b97dde9df8"
    sha256 cellar: :any,                 ventura:       "5c5e7861d774938f0524d4dea5169824ed27abaa02b567b9a15092fd813c32f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70167b35b2341958d234bd248b51157fdff9332994ee9c90b21f663cac11204"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@75"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
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
        std::string formatted_number;
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
    system ENV.cxx, "-std=c++17", "test.cpp",
                                "-I#{Formula["protobuf"].opt_include}",
                                "-L#{lib}", "-lphonenumber", "-o", "test"
    system ".test"
  end
end