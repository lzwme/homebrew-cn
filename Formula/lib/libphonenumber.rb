class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.33.tar.gz"
  sha256 "656c080c0fd713b9bed61efda4b006846d40914b5412d6d7082a5397653e2fef"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6f662e2fba709eac011b1cfb4b10698dfa016c38dd570dc217efd22531ded252"
    sha256 cellar: :any,                 arm64_ventura:  "9d9ea7fbae131ec9f24385e3d9f39172339a19d0fea568fe308827e05161a168"
    sha256 cellar: :any,                 arm64_monterey: "993794f2ca51e4586def0f0470f040383feb2ff8a5842d872ab920b03751836b"
    sha256 cellar: :any,                 sonoma:         "26516feaccbad3428274e551643374193ce04737c7308955d47423e74fa19669"
    sha256 cellar: :any,                 ventura:        "888ed59e2ca43e84a17b571180e9c11180d93e77b983609a56a7fdbb0fcc2a3b"
    sha256 cellar: :any,                 monterey:       "a92c85fafd31287f72b51e8265124d9652cc78efffe353bf041c1d61d863606c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70003c2138aad9077d34cc6698868af173da59a32d416ca6bb2ff08c0282b22f"
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