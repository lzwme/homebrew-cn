class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.12.tar.gz"
  sha256 "2557b16b42da4d0c2e59d0cd17ccd5a134a5f983f56412ab8213969d886cd836"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "21f13e5b260f71501f82b0a17d539503f426d69e7b59c32be68689793d71ea88"
    sha256 cellar: :any,                 arm64_sonoma:  "a8facf044487dd9cdc08f0d70d576ba754223fe91fa975891ba7b62d6a3b6500"
    sha256 cellar: :any,                 arm64_ventura: "6662e1b3aa4d4e1831787eef9ae0caeb7f5ad7e3ba919ac090741a7fb46869f4"
    sha256 cellar: :any,                 sonoma:        "1a9540a19f3ba6baf2daca8bb972196b47b6c6e1fb333896eb860993c4f1437b"
    sha256 cellar: :any,                 ventura:       "64341bf8910092639e7460b9126f0076b0a0d45ef812e3ef6c88d20936d47416"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521b972f32a97462c5c807193385e976b1f0526a4d44b0c468e9b5d5075480f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00e95a9b59bff05fc3fdd39f66a2a07fae2051835e21705ac3d776c8fc9b863e"
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