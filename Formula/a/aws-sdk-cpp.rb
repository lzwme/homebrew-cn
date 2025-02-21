class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpparchiverefstags1.11.510.tar.gz"
  sha256 "0a0e591ccd6f5df5769f436fc087414aa3fb646b727a8e7a121a1b3a5c5af1ae"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "558cf43c059696416ddcde568eb1a245363027a1126f8b2dad8bb043bd99528e"
    sha256 cellar: :any,                 arm64_sonoma:  "6d91e055982ffa8209af39eb1dd105e2cae35ca3b0cdb330fa324d3b65a9a936"
    sha256 cellar: :any,                 arm64_ventura: "2468018f76deffbde0478e1fb33273c341f8df8e4bc1197f59b4b0bcb8d2e2c3"
    sha256 cellar: :any,                 sonoma:        "193f5287fbd22851e98168f11c6a2af55a77d87794fc7b9b16dbcc02cc4d4433"
    sha256 cellar: :any,                 ventura:       "d8a038d701f35590195299463752087d4fda3de2be697846d938eb4b67ae1c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e8d0aca565552a6c18eed8afb393edac6fc69d11be892a6abd54884beca50a7"
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