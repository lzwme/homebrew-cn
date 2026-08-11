class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.36.tar.gz"
  sha256 "43b8fa34f80f84dddc591406d97fbe7f81cf35ce5d83621e67a1b6fa6afac548"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7a3377f5144e55bf5f4e22dc6b2ac7c4ba65ef1994325756aac513449e7e9275"
    sha256 cellar: :any, arm64_sequoia: "3ac47f9897358041c5ecb52b6ee8103576931cad7368c735fcff99433ab8feef"
    sha256 cellar: :any, arm64_sonoma:  "2a3a8cdf376a431357e55fdffc2035a3bb4af5548eae11ab84c99c5346784988"
    sha256 cellar: :any, sonoma:        "84b5b648926d44de685f32063b9afd88c80e47131d58c19cf75e0927556f7a8e"
    sha256 cellar: :any, arm64_linux:   "2aa2fb68d8ad054d34e00c7669f2b1b7eb6e85d894f0c44cdc31e434ea4e6781"
    sha256 cellar: :any, x86_64_linux:  "abd81612d14cc03ecb2a698058d61d7a9674ef6d8cb7b2c148802eb7be889023"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@78"
  depends_on "protobuf"

  # Fix build with Boost 1.89.0
  patch do
    url "https://github.com/google/libphonenumber/commit/72c1023fbf00fc48866acab05f6ccebcae7f3213.patch?full_index=1"
    sha256 "6bce9d77b45f35a84ef39831bf2cca793b11aa7b92bd6d71000397d3176f0345"
    type :unofficial
    resolves "https://github.com/google/libphonenumber/pull/3903"
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