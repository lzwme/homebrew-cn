class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.435",
      revision: "0e8f2e3315ce6f9bd46a2cad8c379823c950404a"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5068b633653b39bf03014e42ba30d4b92016b1243413780fa18b2fd55ba9d6d0"
    sha256 cellar: :any,                 arm64_sonoma:  "372735ff4b52a1cb2dbef9afa3451d7cb11bbb518b6d3c39fd18663a634d0e22"
    sha256 cellar: :any,                 arm64_ventura: "94ab578f9c939462908c1dba27c1d55ed7aef52a93221631d3cab1136d96851b"
    sha256 cellar: :any,                 sonoma:        "f9bb384fbc31fa195dc4d78776b69a178791c3a001eea863232da6b1c670b260"
    sha256 cellar: :any,                 ventura:       "8903ed4a1a18496622719c59229025110d9e56695648a3612b7b24b3de9e6048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd758fd28cd0c9182bd686bd8d3bb0404a478b958112df8f0ccee0bc5fc22942"
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
    (testpath"test.cpp").write <<~CPP
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end