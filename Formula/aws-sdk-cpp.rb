class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.107",
      revision: "fa0b62570cd0528b4ff9ae50351741036c8c7dda"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc8840ef24c8fa8b77fc3cb5475768d63d3716e792fc51e4212a5627ffbf8a7c"
    sha256 cellar: :any,                 arm64_monterey: "21658b9b429f6ed1e8bdccde091e9289ac7ce191e836d03719bb7fa5a6605cd9"
    sha256 cellar: :any,                 arm64_big_sur:  "e7190b769f16e7b00b6e69bae8cb6bcb31b60b5d140166135f470ec409e546b5"
    sha256 cellar: :any,                 ventura:        "e8493736a2a4d205088756e3f1eccef109af465f09c4dd018c850ef67f20db62"
    sha256 cellar: :any,                 monterey:       "b8ece229ef720739460eed25660b17a8c16490932e2ae85107507edbaba36154"
    sha256 cellar: :any,                 big_sur:        "4dc4f7fcfd81dd2f8e2f7108b0aa438314ad334cab0194d702223288cd8f964c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb8cf4cd45581180ffc1f871654a0d4982840f98e7236f6353638405e4628f5"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end