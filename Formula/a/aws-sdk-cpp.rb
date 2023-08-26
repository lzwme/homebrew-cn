class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.150",
      revision: "9a7606a6c98e13c759032c2e920c7c64a6a35264"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1a2fadbe9f256f032575b3451b06d74da59f8a172f9ef8041aa15b22354c41f6"
    sha256 cellar: :any,                 arm64_monterey: "a7c1f3262c9178d5e916addfcfb299f6cd986dd5ed6686cca6edbb42d99bfff5"
    sha256 cellar: :any,                 arm64_big_sur:  "fa64540f20b4d7ad41c0c20e582bf8d78ef5767fcbc4a0638f101944344d0303"
    sha256 cellar: :any,                 ventura:        "39ade63f3da38273b46df6af50e3c332e1c8cee0314467864b2ff78320e432cd"
    sha256 cellar: :any,                 monterey:       "d112d601bf3ff211e82c6b558fb7b09e047da2fec307008d3638fb4d4ec415c6"
    sha256 cellar: :any,                 big_sur:        "4c670b91b4320509b2f27bf002baa52d496944608328c4e01b11e1de459d86f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c5c1dea3c95cdd1e31de4e22ccd346db3c866d6a2ea9fb6b5b6878e170c80a2"
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