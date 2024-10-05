class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.47.tar.gz"
  sha256 "b56ef9dbdfd91968242d63e38457cf58f1c03ddff5a9cb8862dd0138419f6cd2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e1ae202197a6d43e8e0355acb819946759fb480d8a1b9fc7f5cf3dab6fb17a29"
    sha256 cellar: :any,                 arm64_sonoma:  "a1435198085c9718426a289bb16f9f928b9ec9a653c38b5079b5c77219dac8a8"
    sha256 cellar: :any,                 arm64_ventura: "4ca610893e61abf6013a8089d824aacead61ebea4b840434e1ef51802ad1a2e0"
    sha256 cellar: :any,                 sonoma:        "5867593bf398b1d0d5419849f60cb743839cf97db940de97f806874e387b012e"
    sha256 cellar: :any,                 ventura:       "16d5a8084179910da5ae18c8ef9f1ca114bc9bc07e909e8788e1d16ab1387338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb568c65432547cf22b5baca9cd3d3206dc302182975434dc6557875ee34986c"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
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