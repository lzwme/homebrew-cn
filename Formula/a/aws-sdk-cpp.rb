class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.345",
      revision: "8d8e82ede537b8de94f95ddea44e78f845f4980c"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9af54c3abd28a0bfaae213293036ac3fffeee224df4364e4ec91fac9bea4ed0a"
    sha256 cellar: :any,                 arm64_ventura:  "0b88ad1613da040536da8295dc20c40926d25064a5d1318cc0749ee80682990f"
    sha256 cellar: :any,                 arm64_monterey: "1fe6e9055b4196899f38925c9b4dabef4f3e54a8c209929f6ef42d1e2d80b1b2"
    sha256 cellar: :any,                 sonoma:         "53db07e1485c69e50fe5a8d9613d12f00ea63d7823fcacd4b30b9c6e1bba965a"
    sha256 cellar: :any,                 ventura:        "f72eec8a2d018f12d0e4b89cb015214ab1e76ac5bcf952702338eba91f7cac73"
    sha256 cellar: :any,                 monterey:       "9a31c2fdb2af047c5c2cc75e6b8cb97c4266a7f8db4b70ccb124fd2c427df47a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38dc50693937f382d924cdabc29fad982038c29b955f05c0430a1eb7248b4c3f"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2nunstablecrl.h"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib"macRelease*"].select { |f| File.file? f }
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end