class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.25.tar.gz"
  sha256 "de4cfebe1e1da4ecfb687c7bdf312d93b37548737f5e52444d2d29d0b36d2512"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d80a81a0dcca0bb47b340aaf7dbfa3fdebfb57394cf7578f0ee9d4f90d6b5bf7"
    sha256 cellar: :any,                 arm64_sequoia: "954511fe46d68997ba3815f4e19a0968c04bc4be57233516c76a99cd2dda178b"
    sha256 cellar: :any,                 arm64_sonoma:  "924fd6005cd5e7697786193e18357080689b9172505a9d99ad1244396ac8e23f"
    sha256 cellar: :any,                 sonoma:        "e63b26770003dc983ea9fd74c7fa25e925bb2d8638744a8703d50db0ccdcaea6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a452bc9006b81db3af6b1e223daa313ef91db7f10d21aa8087d958aaa8c187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17857b302dee5c3baef5a9f85749934aa1c5c7975aa069bdf7dc74489641557f"
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