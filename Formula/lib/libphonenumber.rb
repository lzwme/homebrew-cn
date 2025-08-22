class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.12.tar.gz"
  sha256 "2557b16b42da4d0c2e59d0cd17ccd5a134a5f983f56412ab8213969d886cd836"
  license "Apache-2.0"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b23620f82150ba729d60abb2ebe8f35501836ed9dcf94b78641f1f990d4e6777"
    sha256 cellar: :any,                 arm64_sonoma:  "25312aa98cee9784c906a2f04fb779959036b18a74331b20b3c19fb6831b978a"
    sha256 cellar: :any,                 arm64_ventura: "e9ec9735921215850ccd7ca3690ad387dea7128051d25a83b20abc067a15a54d"
    sha256 cellar: :any,                 sonoma:        "14707c87be5d51b0dd205837d1dd3daa56e842e342736ab82c73b5ba194cb192"
    sha256 cellar: :any,                 ventura:       "a0b6cf42c7ac7a9a7b9eeb0674d3557c21efc464ab24e3b61ca223c17b3a6ba0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5d5e5e132362f3230ee7cef80dd05e32e954831e86b88327eee39241724800a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47ba0623a0f8ca29b453b33195c56b276c32cf588865795802f343ca33116c67"
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