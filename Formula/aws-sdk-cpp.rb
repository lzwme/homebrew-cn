class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.50",
      revision: "8cd5eceaf258432a25d4fc32d55b59bb4336121c"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd97755edfc65cd37aadb0e688f40d3b65eabcf785b0b3b7ce58d7c1add88181"
    sha256 cellar: :any,                 arm64_monterey: "54ad3b711aa7a5a86cb22aa06e72963b494736ee434e20fee2729c570fd2c879"
    sha256 cellar: :any,                 arm64_big_sur:  "558e2bad3840ff3bcfdae5f955c788ac7e4ce008888fcbae86e656e9fb64f151"
    sha256 cellar: :any,                 ventura:        "1223ab9339c678a1158ca518ded2489efdf45671f4a9a24dfae4e599a94bf4f9"
    sha256 cellar: :any,                 monterey:       "8a1f8db199d31c9ac86396f2b5ae762f711b864c23b7e50faeb1ef3166947984"
    sha256 cellar: :any,                 big_sur:        "8ea76b873d746655b924a563f5b15e87d9555b56e236417a4f621529d2876d2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e4fd70869771ade0445d983490be20908a2bbe231faefe5d246aa7e50ccf2e"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end