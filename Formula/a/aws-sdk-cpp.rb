class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.205",
      revision: "26c6ed84639d4611b58802c3d86182c4b5625cd7"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94897df9b78a5f2e3b6f19d93b17be1e3a9e0f5e3d49658dfcf1df40b6ab6005"
    sha256 cellar: :any,                 arm64_ventura:  "1108017c2c3a9a5684823396d1326cb1741820e94abec352d5b725b0d305f912"
    sha256 cellar: :any,                 arm64_monterey: "e9bd5fd6b3af81b872448c5305a1b1faacdcf076f26b1e9c0d5c93b5d02f604c"
    sha256 cellar: :any,                 sonoma:         "157ad6a2275fbf4f0ff3590748250921f2729a59c3847aa8a68d35175be01a95"
    sha256 cellar: :any,                 ventura:        "60402f4feb79dba767b9a143e2b2ef0cea7f39ab01f3bbb5903233aaf5d180b2"
    sha256 cellar: :any,                 monterey:       "f133c2240960cc13977f1645431da1edbf55e96fa6b17c29e8d1b3aecde7a808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2112264b61088fe67f5be559033c3f8f1fd99e23885c1e22295e87a396f0ec6d"
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