class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.30",
      revision: "1729b68bfcbfdd28ec5de3a94d5792ec4a54d01d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8aa9867a3aa62098a266e2ebeb300059d8baee0c95d72c7d68b5f1d62f49314a"
    sha256 cellar: :any,                 arm64_monterey: "c4847e1e820bb6443213a86cd2c1d7e91f14a73643d43b16a68ceb5f7051fe80"
    sha256 cellar: :any,                 arm64_big_sur:  "0415cbf6902b4faaf38a2e18768983e802aa474ef4fe92041d00e5015394569c"
    sha256 cellar: :any,                 ventura:        "a78a4e19d098aa19cb906fb9a76928ac59f9d169334d7dcbeb41a7e531ee4d48"
    sha256 cellar: :any,                 monterey:       "1fbf46af20812f671ee8f87426f8ff64c5843e4abcdd719db7dd07e88ac372de"
    sha256 cellar: :any,                 big_sur:        "2c97fc4bdc2beaf060d07be5608d23234fa746d8f4cfb7c5189915cd13e5d534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7000e684b3db5d0e8930cd46bdb6d2febc557d690a7efdcd4500b4fd4f6e7941"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    # Work around build failure with curl >= 7.87.0.
    # TODO: Remove when upstream PR is merged and in release
    # PR ref: https://github.com/aws/aws-sdk-cpp/pull/2265
    ENV.append_to_cflags "-Wno-deprecated-declarations" unless OS.mac?

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end