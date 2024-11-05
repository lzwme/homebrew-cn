class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https:github.comgooglelibphonenumber"
  url "https:github.comgooglelibphonenumberarchiverefstagsv8.13.49.tar.gz"
  sha256 "491a8c0d7febb14a36f68f2a5fc23aa8e7e1fa024a88633a638049be66648d3e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bdb20d44491e4cc96604e0caa98c6f4a3644253db66bf03976d1b9d414f9b1c9"
    sha256 cellar: :any,                 arm64_sonoma:  "09f74949de16d2f0bfee0e9d367f971c9e8cd5cbdf5e9418a9dccd6cfc39a0ef"
    sha256 cellar: :any,                 arm64_ventura: "88364877e446ebcc9977373274bf13ecdbc17b2c3f29160e56c7ab610dd49838"
    sha256 cellar: :any,                 sonoma:        "dc145681eb4215f92e51359afab5883c42ddad5a880e0e687539ea6a47ccc7ec"
    sha256 cellar: :any,                 ventura:       "49ff519f43c73ab462a1d15d6cb2068926cce4395d083a71cf709ebe2a664539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "663b5d3b1016f836cd2eac9949a3db4ab67f2ebab07311aa8dd4b6faed3f1ec8"
  end

  depends_on "cmake" => :build
  depends_on "openjdk" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c@76"
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
    system ENV.cxx, "-std=c++17", "test.cpp",
                                "-I#{Formula["protobuf"].opt_include}",
                                "-L#{lib}", "-lphonenumber", "-o", "test"
    system ".test"
  end
end