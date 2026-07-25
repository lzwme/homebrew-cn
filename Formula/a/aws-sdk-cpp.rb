class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.855.tar.gz"
  sha256 "d9cd0437601f56139bbd147461d22ffa9af5669259655b6a25502b2c782510cd"
  license "Apache-2.0"
  compatibility_version 2
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256               arm64_tahoe:   "c037890e0461e181c79eebb73c060c0a1bfaf646655666ac7726870e90f96f09"
    sha256               arm64_sequoia: "81c7f917806ecaf246c91f99dc71f5c9760962ca31704e6208433df90a6ff471"
    sha256               arm64_sonoma:  "f29a473fa7b078ca51ef2034fe6003610311957d031a8f05aea7c28fe6406e6d"
    sha256 cellar: :any, sonoma:        "1b7c72568a7cf92062d7043a47f0af27dc49ffd061e1bc16c7194792550ec15f"
    sha256 cellar: :any, arm64_linux:   "e3cf419b6f1d39bd18c1a48cd5fd176036dd8bc0efba5651b0a282b5e6986951"
    sha256 cellar: :any, x86_64_linux:  "c2186e8af13c0c68eac7d6985bc976640b4ff91a03af90a4adc8a61163b79695"
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