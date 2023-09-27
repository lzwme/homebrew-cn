class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.170",
      revision: "58be026d429d7733969932e0ca9ed29ba7333aab"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "663ff9ace69c1fa5e1347b2d3809654a4c0f137e277a87b0ac0402c7460cf8c8"
    sha256 cellar: :any,                 arm64_ventura:  "f22024eda50e106ce0fb804ffd65fb4b10b469412dc6b6e2cc8911abad18c175"
    sha256 cellar: :any,                 arm64_monterey: "cf72bbee4d1cb9ba72a33e4fa9c9c0f0caf4ff6c1181057a215533cf1da155fb"
    sha256 cellar: :any,                 sonoma:         "d1115d6a32198fc327562ba732821890971dd8ff0aa019935d9a6d11993416a0"
    sha256 cellar: :any,                 ventura:        "125a1efbe005dd652d27d0acf8ffbe2e37849fa03c6d49a996f8f744391d0f4b"
    sha256 cellar: :any,                 monterey:       "9b7e735b9f813fa4655f18be19d98ced9357ad9018c99d3f199494036c7c6e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39053a21867145a00886d1aa9e9d090fd19707e300aaacec2166728681e76044"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end