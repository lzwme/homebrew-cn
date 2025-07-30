class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.615.tar.gz"
  sha256 "4ad44c2582ec08c95c7ecbd9fe3df2d1148b2535a969d28fb1a00e650e0dae95"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "daf58510ae6815f68cca572cca30f1e0d0a8615ace118cdca6b889b9dcbba899"
    sha256                               arm64_sonoma:  "04baf509f9132e2eba8a8559d62b4849a9333056f202cc9a24feb7a923f1ebce"
    sha256                               arm64_ventura: "9498bb60811b239553d2a284bb2d4abf3d3103d143c98081aea484de5f51d077"
    sha256 cellar: :any,                 sonoma:        "8fe88f202460b07b5635157ae42c0eecca25eff05d816669158de25829fb3c25"
    sha256 cellar: :any,                 ventura:       "a246530b5df0c1e17acfb07c325207808556d7e9edb329fa90ecea56098dd2d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e3ba272641ce53c040940abcaf3d36345bfa4a75e49d8e7961f82eec2b01456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8472c8530c16b439f7077a221b894240cab4dceb6ef8bbf4df1ca7f100d06c41"
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