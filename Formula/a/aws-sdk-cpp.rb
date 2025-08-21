class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.630.tar.gz"
  sha256 "3896e2ac13d9615ddfc018331afcf1650e4ba46b2e29a492b439948cc35e9054"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "68cc5d4e07eea91c969a7446276316d8b7d0a013878a60b389e987f085b843ae"
    sha256                               arm64_sonoma:  "c3e0b6da042adb0050bdfe52f99d7b9eaf60bbd3670bfeada407f152d4b544a5"
    sha256                               arm64_ventura: "d63861e0a6444b85ecc1a301ea1f775a5e4d9f9013e734e1b0fadfe36e7393cb"
    sha256 cellar: :any,                 sonoma:        "027c2ce809f10b8a31c9c5fb13694eec54822890d15c44c40b2e6f75d9dc5d70"
    sha256 cellar: :any,                 ventura:       "c004dcba7a0a46a02bc9d747b667ad23c761e69ee41138203dce22ad78350702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "894b9f8320f47474e4810b5685864e49d5b5ace2137dd29f0810c5d4fdb1e1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a449f117605e4f219a4f8c2b16797de405391602b8db19e44913fcb74076118"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-s3"
  depends_on "aws-crt-cpp"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}/cmake/aws-c-common/modules
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
      -DENABLE_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end