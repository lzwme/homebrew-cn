class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.37.tar.gz"
  sha256 "4bd34bc3aec5a89dc9035d15aaf2256c5e8f7e0524e6eb3e7bac1e811987c230"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0893963947db6491d23a91ba9f41d25fe15f4808edd2a2043705392d1e0acaa"
    sha256 cellar: :any, arm64_sequoia: "f272b1aa15fc04a30b4cb8945b79faba58a92949ddf81f40f0035f447dae7e4d"
    sha256 cellar: :any, arm64_sonoma:  "41667c941b91c56b0d2b331d9d38a32a76f85378facc90f886e0e82a7847caad"
    sha256 cellar: :any, sonoma:        "a823cb14e3c29e9fbbe65651b12c6b9dff00efcc4c2bce06cbce3b0b1d743217"
    sha256 cellar: :any, arm64_linux:   "e41db503c235541c20230adb2235e494d158e8f2061841d624cea6245675c161"
    sha256 cellar: :any, x86_64_linux:  "03274aece98ed4a42daa7ba20d7e2375561c6b137d0969b2400f1dfe33a812ac"
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