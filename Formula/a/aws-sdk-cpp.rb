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
    rebuild 1
    sha256                               arm64_tahoe:   "ba969fc9d0318c43427eb3cf24fdd1c1529af2b0115fe2ef99dff651718c9772"
    sha256                               arm64_sequoia: "689080e026eaa889c35e21506cd4b263d06800f5916d6c830d9eaf93a7d9f577"
    sha256                               arm64_sonoma:  "0f3acb54f8f51b23ad01a338b62cc0978f4889f3d9f52d85e16495c65cdc8961"
    sha256 cellar: :any,                 sonoma:        "5afd351c3bb09d7fd80e1bd90ad91ceb48a8205a46267760b99902e145de93d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae728dec763a87776d1e60d304dc114d375d9fb64519c1c28a7cb6e893cb3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0df65f68e7fc21125325ebd53b2ce59e778ea6a1ce8635caea272459ea443375"
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