class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.41.tar.gz"
  sha256 "a72aa8403cd08ff6ade5dc2c8588a44e9c15f0b7b52c9ed5a2973711392d8223"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cef199fdd6efb3bdaabf43491b39115a78a9fb8078d899002cf03d38c9d58432"
    sha256 cellar: :any,                 arm64_ventura:  "f8a0fa6e9421c0c6d29f8bf49c43286f3c638d973d76656d1bd291b0fd599801"
    sha256 cellar: :any,                 arm64_monterey: "6c2ae2862048ab6dc2396542f4cfda56611e017aeba2e5d9d72acb4027ea9c1a"
    sha256 cellar: :any,                 sonoma:         "bce76dea9af8bfdb5b7effb9ed242eceff0a307cebb32ad1fa6517da55273e5c"
    sha256 cellar: :any,                 ventura:        "d96cfae4660a1ba6cf0e1ee02c0f7c7bfe1bf57204f0998230e27756c296a957"
    sha256 cellar: :any,                 monterey:       "2714320eef0a64ea3b95324f204a47138d7036f69d014619bc087516ef46864f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "891416d1709a3d9ca45728353a21f49b8194e415695f9e61988d58e7ccb508de"
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