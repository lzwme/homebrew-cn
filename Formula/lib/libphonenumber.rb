class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.50.tar.gz"
  sha256 "a46b2b5195b85197212ca9d9c0d8dc37af57d2f38b38b8c15dd56a0ec3a2cdc0"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c119c5f06b80738e99fe15ec4c1190ee79ff9d29a126ae4f74b85fa47cf6bdbd"
    sha256 cellar: :any,                 arm64_sonoma:  "2fffabfbeb44fc5e8d31ad0bd6c33b44345a9def37cc7229526ae898682c3d2f"
    sha256 cellar: :any,                 arm64_ventura: "2c04938948d2c31b52845ef233415f88fac9cf83a95b3d5cc4a2e67d171ed0bb"
    sha256 cellar: :any,                 sonoma:        "9087f4947fcc00714ef5ec4853d2fcd41763409b42c9122f62fbaf4196dc08a5"
    sha256 cellar: :any,                 ventura:       "6930422f0d4f4917e8e844ccf3f1a6adf940f5d907d8149ebc191c6c430261a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "579bd9ce342bcd3a7993ba0a2a89d1d83e1c6fa81bc282ba679d0044eb3f343f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
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
    (testpath"test.cpp").write <<~CPP
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
    CPP

    (testpath"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      project(test LANGUAGES CXX)
      find_package(Boost COMPONENTS date_time system thread)
      find_package(libphonenumber CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test libphonenumber::phonenumber-shared)
    CMAKE

    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    system ".test"
  end
end