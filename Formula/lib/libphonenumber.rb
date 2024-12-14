class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.52.tar.gz"
  sha256 "672758f48fdffcf0be48894824c72c729c07b914a04626e24fa01945bb09ca53"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0a2052f155bc7e70bc0a4c46ed6307e790d3f44ee09624956f0f4908e0e4efe"
    sha256 cellar: :any,                 arm64_sonoma:  "dab4af01874420c6ca792c9e7349ed4e287b1db5212c758c5a9f414776ff56c7"
    sha256 cellar: :any,                 arm64_ventura: "7a47119bab241e9326ea9ce9738cb7e5c49127924226654933f472f437216fed"
    sha256 cellar: :any,                 sonoma:        "adbc23e42040d0c6637b7d78e3200269234f1e267e5d7edc4eb90cef8c42b6c5"
    sha256 cellar: :any,                 ventura:       "1eb1c1ca954499cc648c6d31551dbd26fb6769818d2029cec208459289a88a4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b0043ea1275bfdbdc60d990fa1c72012b0c3eccf9d187c09f727f943b234bab"
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