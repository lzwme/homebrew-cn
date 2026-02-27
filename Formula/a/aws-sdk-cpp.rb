class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  stable do
    url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.750.tar.gz"
    sha256 "053d1f9a166e1614bef2691d652c800e5a0546f6fdf7676047ae62fb2ee12b64"

    # Backport fix for missing headers
    patch do
      url "https://github.com/aws/aws-sdk-cpp/commit/175e80312cba3d2aa8d6ac0069d2a19161b1f273.patch?full_index=1"
      sha256 "e30e650e724023a852b6f7169babb5d323c3de85e75394cfc02bd10650167df9"
    end
  end

  livecheck do
    throttle 15
  end

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "bf22d8e6396b6f3fb60be214207e84e0c5b80b11bd3525b600a5c62fe261785a"
    sha256                               arm64_sequoia: "9bf737ddb7b2adc41765db96251589ef72284e56ef7008b5e986c64082b9db36"
    sha256                               arm64_sonoma:  "66c2d06aec56ba3ea073212bdb1130bfa0bf1ec2e9b7815428a3b5f3c0331871"
    sha256 cellar: :any,                 sonoma:        "b738f5bb473c0d2b4fde59d0f871337845b519563821715e86d7b698c934a3c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43e1b495c8fead310585c3b44ddc25b890853034102c6987c86350a77061a4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc3bacedc9060ade38b5d33dab97dfc38b4cbe15d8d3897971ee61c07e3b260"
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