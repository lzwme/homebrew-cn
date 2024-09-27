class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.46.tar.gz"
  sha256 "542460d54826de4c48a933e17eb92e2aeafc1e9fa93dbcfd4a4864d37a61d569"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "136f567369159f60cd3689cde9bc7271e0cd22f8409c5f0a37fefcdfbc4fae5a"
    sha256 cellar: :any,                 arm64_sonoma:  "a00ff9ba1202a177b5450a5b126f1cc4dcc682504cc4c9e5ecbc5cdc19a54c9e"
    sha256 cellar: :any,                 arm64_ventura: "08edcb2624fbdf761fcf77059b82166db6e9850975e9116444b789a586d0993a"
    sha256 cellar: :any,                 sonoma:        "869c66787c2febb656edba3a359f271637134da4d393424abba6f354dd53358a"
    sha256 cellar: :any,                 ventura:       "d55adc879b3a63c34ec6825d121e9facf885a62e10fb4db1c7cc679d2f013680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aad13816e7e494fd5050117a4079264d58b8f77b76546ba8d9e6fb57332669be"
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