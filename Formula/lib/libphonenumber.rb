class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/refs/tags/v8.13.24.tar.gz"
  sha256 "7fd7dd2561b54d744eb805b4f7fd251d90ebe1826780c43fe78a4262c55f40f3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb99f9974b5e3b998763e26ebcffa78f610dd0a78952b0bdadd77ed56f5a0422"
    sha256 cellar: :any,                 arm64_ventura:  "00116642ad7ef289c845aedd35d3cbbf1f69185148ce6e4dcd78ed2ff51214c1"
    sha256 cellar: :any,                 arm64_monterey: "dd58b2308e82fa6bdd579e36fd2538174e181d2cb0fea9abc6b9cb4b7545d9e0"
    sha256 cellar: :any,                 sonoma:         "e1cdcf13b507b24c750d09d181941d084e94740e32e12be24327681c73d0a97c"
    sha256 cellar: :any,                 ventura:        "d9dad74e03247584570939b86ffc06bbe030cf50ec2f2e1a60b83846e4c1cf1e"
    sha256 cellar: :any,                 monterey:       "9761895bf9b448bd3b2e04d2849577c3092462d89521bdb863fd5effc55067d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543c753d6628c9e58759f88fd388021efc333b8ff0898806dbf70b25673dd3ef"
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