class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.108",
      revision: "a5ad600d0e27741ac987c710b40d53123454e5e8"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4449873eb74b7f3fac7edf6f5e2f01f21b6c2af93f5dbfc3783923ab48c1adb4"
    sha256 cellar: :any,                 arm64_monterey: "cb188ba1b4579abc7a8bd55744a2b66c99a136a3d6994ddc8202e8eb086ccd89"
    sha256 cellar: :any,                 arm64_big_sur:  "cd8abf55d5170fc4661c96da4d1e59c7c4c7a0feddf807abc53e96e2f4520b02"
    sha256 cellar: :any,                 ventura:        "b0dbe4f6f86d8d9217826509fba2fa1df565b2aaea16899053aeff0ac6b33430"
    sha256 cellar: :any,                 monterey:       "69be492634b46500f86e4f257fde527f38c7de3fd255a0d810252a968ef506d0"
    sha256 cellar: :any,                 big_sur:        "49a185a2f02d24aa8e6fdfd08119cd6f5b83dd73b6fa1378ce0841b71b24e172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c2c6c4932752ab9181e603242707af71e76777c26f8bdbee30243fd2694131"
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