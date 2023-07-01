class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.111",
      revision: "2fcf454a9893fd40cfe3de5aa929521ed7f1b370"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "11b83af9d51fc2d35cc1050f253865bf9ce93d96a486dcd269098cba2bb76bc6"
    sha256 cellar: :any,                 arm64_monterey: "9f1eebaf9f354038b77b5f0853cf261ce1281e9f8c9582fedc8b693a07a463e1"
    sha256 cellar: :any,                 arm64_big_sur:  "47dcbddc6c05b3677dab3b341f3aa0a61bff4ed6c5aa92146529d87c4611ae35"
    sha256 cellar: :any,                 ventura:        "aea60d1223fb87de757abedeee48c1415d8b7bbb5dc325a79860543e0ef58e8f"
    sha256 cellar: :any,                 monterey:       "4814e81d4d7791647ae2461de70ace2f82aca5e710679861c7e66379c015379c"
    sha256 cellar: :any,                 big_sur:        "b9ec3d7efe1283063a7d52bb669e9f0dd9b671686fa65f932ca9b59d7588cdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e422a485318cfc4f9b18ff6c55311e908ab30ced0ba1b3bd593381013bda199"
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