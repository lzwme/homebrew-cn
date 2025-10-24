class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.675.tar.gz"
  sha256 "af9d7c3a97db01ef9186764bc4151a83b37d733667126363d2daf2838cd3c5e0"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "1bf21fa239afaf6b23003cc6775b90f9329aa71a7ff8a46f21766cfcc10143d3"
    sha256                               arm64_sequoia: "9dac5db620881eeca74c95e7e0d30975073088bf3ea0b5cc987a9e87c471ead6"
    sha256                               arm64_sonoma:  "8ff4abe1ae12504be40d7e3b7a2602d7a673cdffa6dd92cb8f646baa8bd005f4"
    sha256 cellar: :any,                 sonoma:        "81698fae168971f46108619e266da6c768bac1b684c31025c46ade6ebf243b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c95d91a6056c238338f726fb56b9577223f4d9cd573d4e0a84dd2f560b8b9ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf5b4e7c5cd1f6ddfba1c53345d5a48ea0b1c5570eebed39f72a60efa4672f1e"
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