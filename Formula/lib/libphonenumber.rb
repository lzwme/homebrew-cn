class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/refs/tags/v8.13.24.tar.gz"
  sha256 "7fd7dd2561b54d744eb805b4f7fd251d90ebe1826780c43fe78a4262c55f40f3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7bfca92604f0870e43b886402568abe249ff33d68d080d1b2fa7ee0b344645c7"
    sha256 cellar: :any,                 arm64_ventura:  "dbf30edb4436cbae1bcbb970de11aec0e53ecaf9f3956f3050af1ae1ac5c73b3"
    sha256 cellar: :any,                 arm64_monterey: "5061d267e90b8c69e0719aa724b02e2aee3df44cd5a7b9bd1f215042bd05447e"
    sha256 cellar: :any,                 sonoma:         "da0e1c25b3df1af6984c92ec24fe213ccf4113a3adfd887b388db434c7faf3f9"
    sha256 cellar: :any,                 ventura:        "1f6d9941eaa7b281c9ba50ce1485594eb0578d415d5d2f34eec61f6cd10d6f79"
    sha256 cellar: :any,                 monterey:       "7b5c7323f1b780845df76d45e1ba10fa338f4f00318715b5d0f5863243510d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78bf0cb23546d666cf301f8edd8d0673e750508e0234b42755c7af08c405f2a2"
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