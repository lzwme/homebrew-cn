class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.13.tar.gz"
  sha256 "46400323d2df4fdefd57bc46a34111dc2c4612da62ecd0cedebff5ad94e49b0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52b4755f0886aaec29c4f6d4c85a510536137f9846d71bb864f589ef48480a19"
    sha256 cellar: :any,                 arm64_sonoma:  "9df840a677f0281f939752b1d854e5473a44bcff8b2322460d4b0786d576999c"
    sha256 cellar: :any,                 arm64_ventura: "88ba49911af87e3c484bafe0a89e71d709b9119a3ecf99f7df377315e2f672de"
    sha256 cellar: :any,                 sonoma:        "e72b14def1071a79b7ac30d2c7e4bc4769a340b3eed2c26470d5ef1d5f393fb9"
    sha256 cellar: :any,                 ventura:       "d6faaefd61fb1607c25edb9cd6d9e6ba4251b6bc80883da7776e61fea72918a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "822c300a4c2282b95130a2e8fac3e525d839f215f8672c9dd191da9f68613f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52ffd9e1f4e8b574ac63ad98e34fdff091bf3831ca9bde574b0136c60cf7dd39"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0, pr ref: https://github.com/google/libphonenumber/pull/3903
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
  end

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
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

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.14)
      set(CMAKE_CXX_STANDARD 17)
      project(test LANGUAGES CXX)
      find_package(Boost COMPONENTS date_time system thread)
      find_package(libphonenumber CONFIG REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test libphonenumber::phonenumber-shared)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end