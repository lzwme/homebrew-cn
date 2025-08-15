class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.11.tar.gz"
  sha256 "80a53c5da67c6240e15ca9cbb2cf263e9875fd37415464892b5cd1a00b1e2dba"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "378778a81a61a5c8e4afb0f4dcc34283e953c087790249e72439804e6a4deeda"
    sha256 cellar: :any,                 arm64_sonoma:  "f743bd2e1ea07ee2b138f81b03c8cd5557dc16117f1ed6c8fa837d4c4406f6c7"
    sha256 cellar: :any,                 arm64_ventura: "39935b680248829bdb31bbb3ef2bded018c66d9c74fe309a93710e18fc89ff79"
    sha256 cellar: :any,                 sonoma:        "8cbab1cd48abfd54173bf83f3a6ddbcb3bae9e1ff6d9471e754c042e540da901"
    sha256 cellar: :any,                 ventura:       "f6feb87351aca611dd34c966d725ca3edd5df4e14351ce2944c0442a10c2db6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bad065572002188847b01f8bc898edacbc51a5e87265d879ed46357cb5ae3991"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e3698bece7e19fc78431ac8301ba62ad14602b7109a3ef550d64b58efb86ee"
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