class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.52.tar.gz"
  sha256 "672758f48fdffcf0be48894824c72c729c07b914a04626e24fa01945bb09ca53"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dec96133a5065c0eb6cfd686151815c0369ca4867219f0c9f92166a532ee51ca"
    sha256 cellar: :any,                 arm64_sonoma:  "0c44bc4579fcffe0248965542521cf5f937f6ce2c7bcbc1d54fc7ac60e4706ea"
    sha256 cellar: :any,                 arm64_ventura: "a2df3abaf0c068fc312e0869e34792ad9dbdeec9a8398ab47c5de1143a14d994"
    sha256 cellar: :any,                 sonoma:        "53e8db37ef9cea715d4786abd31221ef637f9bcb854d9d07c0874e067f19c844"
    sha256 cellar: :any,                 ventura:       "ff58f8fcb015cdd1b329503dbd8b17c10ac29a3e5f4cfde0cde955c6e6ba044a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abddf5862d6fc212bbd7728f930ae73d121cbca6f965743458b985d4a6e6cd68"
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

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system ".buildtest"
  end
end