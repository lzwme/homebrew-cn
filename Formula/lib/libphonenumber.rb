class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://ghproxy.com/https://github.com/google/libphonenumber/archive/refs/tags/v8.13.26.tar.gz"
  sha256 "a7df5f274dafa0b590524560fba72f561284a224344272fa8b2101677a7aa317"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "856da5eb9663f9e883f4f79b87f147a228edae572ade8f4ab3c0d7267b3422b3"
    sha256 cellar: :any,                 arm64_ventura:  "cddc6c781ed229d75e873fd77ac80fc34420b7346a6e6e5a2783c897de5776a8"
    sha256 cellar: :any,                 arm64_monterey: "6452463686763982a0e1c79a07c6f4d669701031048f323047ff913873026c67"
    sha256 cellar: :any,                 sonoma:         "de9cfb5ddb1d817f1c74a92fb14f6c476cd13dbcdabf63ed60c47656fb0b0cfc"
    sha256 cellar: :any,                 ventura:        "6ab011256162042945369dbcee1c73603ae0b7975d447942283dc9bcee29c998"
    sha256 cellar: :any,                 monterey:       "fd0bb2fefcde4ca955468e1795003888a6c47e65c9b52443746635ac398730a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4af45751afcdb76634e4ccccde5ccb57dbf8ff00039a85f6cef63bcfa60e9b"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end