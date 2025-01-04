class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpparchiverefstags1.11.465.tar.gz"
  sha256 "3bf855c882b93d72d2da8e4e829ba29b66b85fa28f548fb7499e7a96d6a22315"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "73b931a6918cdc4fccd5c9b88d30b752658b97b6320bb5eed4daa2da47cf92ad"
    sha256 cellar: :any,                 arm64_sonoma:  "c31d543c90452234bdf8bd18c58964ba9dde2dd046e7b33aeda9e1686ba575e1"
    sha256 cellar: :any,                 arm64_ventura: "da07bb2877c1930bc800f1c824c4b77262b3950debf1a77d6ff818fdbd57f643"
    sha256 cellar: :any,                 sonoma:        "aacd12280b7a1e2b7fc18da93e5e4f05cccf8f74fbc92dbf85e7622c62445a71"
    sha256 cellar: :any,                 ventura:       "e13fcf987664eef9bae1e55f297d0ac384da05858690f41090cd124689dcf658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f0f53586d0303e8589fb814a8623326c6989f488aaedad8cf96e31448f2ff4c"
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
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmake
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