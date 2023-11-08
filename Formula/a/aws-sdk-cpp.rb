class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.195",
      revision: "ae662b4942f66cb1c5ac93951ce08b1a721faeec"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5fa3bcff67d89a0bceaebc38894524c4057d5c116dfc912668dab5d8668a16b6"
    sha256 cellar: :any,                 arm64_ventura:  "bd4620d00a5124fcc613f54eee6d9dee816e9a96cacf60959cce6ceb4f790ca4"
    sha256 cellar: :any,                 arm64_monterey: "6930e7bf0e138ac3e912a12cb2abb9b0f710a9fe4eaf0090d304a2d4341be635"
    sha256 cellar: :any,                 sonoma:         "b6ee6dd25586e466cd411705cb629e1f7020069f631fc6fdebda46a892737c41"
    sha256 cellar: :any,                 ventura:        "19fe80b4cac852790cc2913b4112ef517ff8c7016125dc3891b7b030f56d2510"
    sha256 cellar: :any,                 monterey:       "b5561d15599e66ddcf28b00efec560842c96438335bee726370a93338e019477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d471ae197fc22e5998ca3c49203e349f1e4d7b0a25fbc56e3f85339379889fc8"
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