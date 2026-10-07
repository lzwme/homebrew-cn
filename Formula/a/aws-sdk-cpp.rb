class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.900.tar.gz"
  sha256 "35a895edbcf174ed8587859af62fcca85868e82034d019a5e584e27893dc7909"
  license "Apache-2.0"
  revision 1
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1d8812e2ac6c10a62cf9a864b60cd3740dcd780d0fe73f0761ef7baa1787554a"
    sha256 cellar: :any, arm64_tahoe:       "24465b8c7f4355450d8bcf1e830344159d2462fa0f10f2d40f2114cf39787642"
    sha256 cellar: :any, arm64_sequoia:     "fba15b9feeffcd7f6c0b83a3de3e0a5ad733bca20e6bb0d375120c657be2a73e"
    sha256 cellar: :any, arm64_linux:       "fd76e94c417d33ac7ba64bbb94923e1128aac36cc436ce3cda3eee5c0441d14a"
    sha256 cellar: :any, x86_64_linux:      "a11bed0f74d4e7f3691fbbd016d73176ecdec2cf26b5535355f562ee9235f888"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{formula_opt_lib("aws-c-common")}/cmake/aws-c-common/modules
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