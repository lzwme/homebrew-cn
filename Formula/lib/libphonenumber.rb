class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.45.tar.gz"
  sha256 "831e73649074979847cbd46c78081a8552bd75cdf65e259b426a3247e532b686"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "76d8c3805cef84d67cc9ca4c5c1e969ff6535f002d784b28395a9741c8c543d6"
    sha256 cellar: :any,                 arm64_sonoma:  "2f17b64a4c28478eb1ae20797f33d97b9118f44b82baaa67bce7b4424fa4674c"
    sha256 cellar: :any,                 arm64_ventura: "27d8b7ae774cfb22ca45498497d73a960e825ffcf202bb78ab7d54e0ae78b9df"
    sha256 cellar: :any,                 sonoma:        "40a89e06f26728a07a1414bdf3eac2b0194df6cddea1b787859d0ee465603976"
    sha256 cellar: :any,                 ventura:       "cd19a6453f9204462f391d548699495b92ad9a6b55cf650405b3d9365fa4a05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167529f6c4009132b6a4a845ece49753e81b828198099466312d9979750906c9"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"

  fails_with gcc: "5" # For abseil and C++17

  def install
    ENV.append_to_cflags "-Wno-sign-compare" # Avoid build failure on Linux.
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <phonenumbersphonenumberutil.h>
      #include <phonenumbersphonenumber.pb.h>
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
    system ".test"
  end
end