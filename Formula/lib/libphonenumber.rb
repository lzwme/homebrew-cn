class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.11.tar.gz"
  sha256 "80a53c5da67c6240e15ca9cbb2cf263e9875fd37415464892b5cd1a00b1e2dba"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab41f75946f42d4b4ab499208ab6fda917252a3f98d75f237f810eea39505539"
    sha256 cellar: :any,                 arm64_sonoma:  "c84b14bbc0047b3fa994e7ad9dd6ceb86ca8525f6ac9246ff7c2ca4327b536fc"
    sha256 cellar: :any,                 arm64_ventura: "9bf528829c672212d823ee41197225ba3c8836149b8006b1f4efb625e1681526"
    sha256 cellar: :any,                 sonoma:        "f0eaf2fbdfbcfca5f0bac59c5a4759e9746696c82344d1f2a5597b5de22f013d"
    sha256 cellar: :any,                 ventura:       "e32bdfb49e7d9827834d587cf4fc51177c69b3a70bfd964bd54c613bc575be62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0521b38b694219f8894831fece0aca29ba82b1673c80b35dffc963797438aad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85a4f59ac41e6b77d03621c0824666ee2bebdea9a36f7f976368f54a00658674"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@77"
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