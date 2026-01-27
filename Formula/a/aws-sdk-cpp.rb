class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.735.tar.gz"
  sha256 "a977236b12b8c16c9a31780723e35f838cd07c44a08dbd34a7a385ed0af7b573"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "e53d5a02af5325d77a5c34e793ab9dd2e6d70ca8f4a0a8fad8138c517aa2292a"
    sha256                               arm64_sequoia: "2dbd3b6aaf2444a0b73b1e071b7d9e8df67d456623f748dbbde1870ee1e1d8bc"
    sha256                               arm64_sonoma:  "83b1f9f085cba7df4b3c6e273c701b74fbb3610485964b8a0b9b19cd47819fde"
    sha256 cellar: :any,                 sonoma:        "c4b5a395bc70d42c95fcea0cc2dc74d2b07f6dafced10a810961b11c9cc13c81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2b795823c22f74e808322ff764134b8fb065cf3c1068e40447bccfedf90ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb5a3dd164f5b845f2faf322543a5f8d754158f0e7cce3bd4846be395af8a58"
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