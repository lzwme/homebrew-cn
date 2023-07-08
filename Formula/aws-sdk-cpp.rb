class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.115",
      revision: "94cc9d098d9f0f15ee0e17e5f0be3ba37d0a1cac"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d06a39264f8349b275a67855daeb27e8ccf8c0fac1fad52d68d8716fcdfcf91"
    sha256 cellar: :any,                 arm64_monterey: "c3921d7a22f2388bb6dd3d2726bfbff74f32b612096689ee195b5817c25ae39d"
    sha256 cellar: :any,                 arm64_big_sur:  "ba3d75645a92ed804af024cec1face709dc94085de4ec0d6b79b8140bb338c33"
    sha256 cellar: :any,                 ventura:        "f08bf8306a5e23ae80b20b58196771f9a1dfb811b0c7554af45ce4bd7bee11f7"
    sha256 cellar: :any,                 monterey:       "375163cdc689c36b88cef932698d4eee224772a32dc37078a5f7bd8e399c7953"
    sha256 cellar: :any,                 big_sur:        "deca66beb6ea4892493e658d365af5840a7a6f46a1fe58ec1669348679f46b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ef0a635c0fbd13fa3ae73cdf65caa04cc49eb4bdb01f86b4da10c4fe062cca"
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