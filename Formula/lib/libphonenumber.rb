class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.52.tar.gz"
  sha256 "672758f48fdffcf0be48894824c72c729c07b914a04626e24fa01945bb09ca53"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f9d906ac50082edaa863e023e790a8059f71362068b6b87083c2749e709020e"
    sha256 cellar: :any,                 arm64_sonoma:  "834dc66ce128813dede8c7b73844965ca90485697d0728c24cfc09e4baef8c35"
    sha256 cellar: :any,                 arm64_ventura: "47d6b974debd630cc154af7c2598191fd853434c0ef11fdfc82862c6e860d9aa"
    sha256 cellar: :any,                 sonoma:        "c8b4b905e7eb1ee7235f313bf0f32cd9186c747079a371db125021d79afc0296"
    sha256 cellar: :any,                 ventura:       "32c5e5649cf10423c78309e38ce8250d6747ff7d1fb558d67fb20d338b2301c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d89328a35661597724a9689bb982611d34da7779754e320e1ef05ea4f1a988e"
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