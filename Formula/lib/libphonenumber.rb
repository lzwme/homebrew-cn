class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.36.tar.gz"
  sha256 "43b8fa34f80f84dddc591406d97fbe7f81cf35ce5d83621e67a1b6fa6afac548"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "47f71e059ea12da1e4ef60542af16ec889ccca329500af14364dd7b48fdc2ac8"
    sha256 cellar: :any, arm64_sequoia: "83961c5dc683c5522d1dbcbf15ecfbbfa79e41bd5568fe2e420b7512ddc8368a"
    sha256 cellar: :any, arm64_sonoma:  "f21d3f79958568209486243e70acb3dab778df4638646a74c8239ff2bca2793e"
    sha256 cellar: :any, sonoma:        "7133254d513ad9a95245bbaac5a89451d0ce58dea42311cd622fb00f236cf272"
    sha256 cellar: :any, arm64_linux:   "0d65bc086d86b51e608e23f9ee01322e85a12c2a32a65313689e93d278c03db0"
    sha256 cellar: :any, x86_64_linux:  "d4f0dff8c8b1d7a0377f3287430dbdc65928590ffcd88b00f04ee89aa4766776"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@78"
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