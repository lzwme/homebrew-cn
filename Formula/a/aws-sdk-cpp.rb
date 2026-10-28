class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.915.tar.gz"
  sha256 "14aae4edf6c1b389c2e43ed077889e767dd768495846a3f506c240a1e478f460"
  license "Apache-2.0"
  revision 1
  compatibility_version 3
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee8c7e4980d52234dda8c61d6dfc8bd876954ef9ff57a30b29c1655bf25dc6da"
    sha256 cellar: :any, arm64_tahoe:       "2261720a478964174ef163df56e96190e92c0ee591f499dbb03109f224fa0301"
    sha256 cellar: :any, arm64_sequoia:     "2afb7f67bc8ab4f7f41a1a1f30fd1cb4e4a15e494ab0e60cb4296628f25525cf"
    sha256 cellar: :any, arm64_linux:       "ca523baf9b439a40430999e03e95b76f51386516cb79dbf1dc2b8dea40922358"
    sha256 cellar: :any, x86_64_linux:      "5402ce42a84ed3f14de10ee8bd2bbb7693947cd3ae1d494df567b7304c534987"
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