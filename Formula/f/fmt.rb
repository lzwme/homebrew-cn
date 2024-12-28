class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https:fmt.dev"
  url "https:github.comfmtlibfmtreleasesdownload11.1.1fmt-11.1.1.zip"
  sha256 "a25124e41c15c290b214c4dec588385153c91b47198dbacda6babce27edc4b45"
  license "MIT"
  head "https:github.comfmtlibfmt.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "740ac2d7801d773d9c710de3c5ce57ee166dac98154482e528fe34a498273b2e"
    sha256 cellar: :any,                 arm64_sonoma:  "dd19b62215387ced15630303ef095b13942c0a512e5702af7132f54ed657d5a1"
    sha256 cellar: :any,                 arm64_ventura: "0bfcc566187f698eaed4ebbc3a4cfbd7d3dbc77bf241a49002ab5ae2d153e302"
    sha256 cellar: :any,                 sonoma:        "229b5ef5bda903f2e176b6a3206e78c9a57b02e0e316a48582dc0d8c98455354"
    sha256 cellar: :any,                 ventura:       "4748963dff6039b723842f98331c07a603a94c281d3b0d3ef1ed7f13f5641e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8993a605fed9279affcca6f7d456f76a755eb908640bde0f12821e89d394fd98"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=FALSE", *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-staticlibfmt.a"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <iostream>
      #include <string>
      #include <fmtformat.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output(".test")
  end
end