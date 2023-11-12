class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.200",
      revision: "7ebc08a48a788a45f7e6295ef8c11416f711c5db"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d4cfe1930c6b424c3f8bcc6bb393b2b2efd1c57cc4ee419b11dc9bd83634a885"
    sha256 cellar: :any,                 arm64_ventura:  "d9bb9e6a312269fb1e59d3a7f638d05b98c0a5dbeb2bf8adbd00df36cc21ee16"
    sha256 cellar: :any,                 arm64_monterey: "b19dff5d11072221382bc8932bd67c8cdaea616dcab2185e52c590c4089117a1"
    sha256 cellar: :any,                 sonoma:         "402677300cc02788fece63549a2b7824878a8891b361cb8e666cdc5ffb062fb1"
    sha256 cellar: :any,                 ventura:        "42453e901a9cc5dd4432ae21ea7fc9cb97143357e5b4aa34c6c3b95863462903"
    sha256 cellar: :any,                 monterey:       "b2d7e9d15fffa87043cba3a8008b747611c849c5fe24085ceea6b23712c50781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5951f6f62d9c9a87b3472eaafc7bed070261458e0764eff6ce165bbc71db551"
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