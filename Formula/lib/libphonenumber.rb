class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghfast.top/https://github.com/google/libphonenumber/archive/refs/tags/v9.0.16.tar.gz"
  sha256 "c6413870b130cbeeb368012d2332f49c32e1914a2a33e089d206678d6d18f16c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "be3c5a257a38f130fba579b093caabf91217dab5ccfd78aff87b52e920e4a166"
    sha256 cellar: :any,                 arm64_sequoia: "ae2a7e82d5a9812a5001c44d7e4af1a2326b201dc2b90f34d178159a9f72907f"
    sha256 cellar: :any,                 arm64_sonoma:  "af20b92a76586ddb54d46ccd2353fe514b7b70a77ea86a1c249ae023d2a3c341"
    sha256 cellar: :any,                 sonoma:        "9a3ad839582832ab149750d9ec15be45a1977e8728ff7810760b4063fb4de575"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0990ee9fc0505149facae86dfaffb4ec3b52b9345c51dbe309f7c9a0bbe320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d99476ec7aca8cd98fff5797e460b25f851505d584aad53b11b5a553078cccda"
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