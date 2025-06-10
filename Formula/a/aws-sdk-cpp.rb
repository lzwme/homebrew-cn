class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpparchiverefstags1.11.585.tar.gz"
  sha256 "491e5c2a8f6cb415b1a4ce6afaae1df19789edb0d732adddf34f990778d0db59"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "ec3d864ee3b1a59e4855e3bc425ac3a4424c375ff1eac4ed012ae3d6df585e77"
    sha256                               arm64_sonoma:  "d620144989639fbe14428fa74fff1b27621f6c95e92ac05d57c754a77f6e1ccc"
    sha256                               arm64_ventura: "e1299e49e8cba8f126e1ca385ae26cfcbb7e57458f3f9a7c34fdae27f69dd0e7"
    sha256 cellar: :any,                 sonoma:        "67b35525c5575f0ad0a817b90042954e7bd05831931441c95246198e211e64e1"
    sha256 cellar: :any,                 ventura:       "f53a5327254d10cac33632db3f39b92b9adde61db9f47fd09083cd9a51bc5200"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6c780f1ba4548055189a2775ce2c47a2380e46f4834cbd8688d5aed3bea5437"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e47a642b209b57cc9f9f6249cd7274349f2605af8887e9bd0db441f367b0a6b"
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
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmakeaws-c-commonmodules
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
      -DENABLE_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end