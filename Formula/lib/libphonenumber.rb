class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.51.tar.gz"
  sha256 "c96da523824546a91b4bd6753a54f2ab7f4979d87729407170b58066e245f5bc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f74390186fdcde8e17735bf081014a2b56d56893619bd41905c7772a8a680ec3"
    sha256 cellar: :any,                 arm64_sonoma:  "8b132b50b3877792eda43cf91f0e3f9df6f1763ddec8154f7a68f51b8fed124b"
    sha256 cellar: :any,                 arm64_ventura: "34db0b799366e2c1b0aef0ae5476a0a5797ec90b4e808263e5f4d1f460002ca7"
    sha256 cellar: :any,                 sonoma:        "2dab1b02563fe80d3a204c7d56f62fcebbf4d0a0070a063286ea155e6a3c4cd8"
    sha256 cellar: :any,                 ventura:       "be47e927d0fbd12feeee7a3c5bd2c99173a084840f98663bdef633ab99160e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3761f8f7e3769a608f557f03f903cfb3bbd23a07e9e874210bfe7d282dee49f7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
  depends_on "protobuf"

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