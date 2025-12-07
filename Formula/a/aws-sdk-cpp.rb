class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://ghfast.top/https://github.com/aws/aws-sdk-cpp/archive/refs/tags/1.11.705.tar.gz"
  sha256 "9b2b7d572980ce0be1239199da441588eedda4c6b4e82d28e53b1ebbe91cbd9f"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_tahoe:   "2ed03f47637b64f869f208f0c83258fc174bdef00ef9a33f1b9777d54b1c1370"
    sha256                               arm64_sequoia: "be3c75b67330b99745ecae2e2bfada1de60d9edfc4f7f363f1ec2ffb33531eb8"
    sha256                               arm64_sonoma:  "a2601b2faf557b1f80568a73fcb0298205e62354b780649bd430cc3a62b93800"
    sha256 cellar: :any,                 sonoma:        "28c84dc2f11e587ce1176f1475aa3e4ba32b76d818af8fc5360debc7865e2ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73582181ba999d52bee256b02b12816d691e8524435f332c8ea5e86c5c90768e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30f3728d81fa662b13afa4e0e0b5211059b713a0a441bfe78d415a64b614364c"
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