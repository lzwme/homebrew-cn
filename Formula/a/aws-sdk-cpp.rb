class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.160",
      revision: "8d2360fc44b192d40a4f8dc5aa54dad6f795bf83"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "21d23d82fe0f7fac6323ed292e80fb5a77205786008187c6accb5699e458d5e6"
    sha256 cellar: :any,                 arm64_ventura:  "e74332e5f492b9a2cca95bfea41dc575ad669b551fcd42dbedb2fb63a19e0e53"
    sha256 cellar: :any,                 arm64_monterey: "5ed062de991716ef57e04925401f8bf8e55fb40f60a39dfaf94435f5c99481cb"
    sha256 cellar: :any,                 arm64_big_sur:  "f9aa40fd93627659c4690578473814f934e8c7cdfcc99ebeb799a468c3f0dd9d"
    sha256 cellar: :any,                 sonoma:         "3f18a9dad4e63cafb9a1bf1fa54d7967eb44d4df231b978914ef641144389291"
    sha256 cellar: :any,                 ventura:        "7944ce0a2c154499fc980f6ea38b31a63db0d9de05387739596b20e47acb5038"
    sha256 cellar: :any,                 monterey:       "4dd9ee34a44719094730ffcc2b50ad0500d54ed03f58b647686f4891987848fb"
    sha256 cellar: :any,                 big_sur:        "45eec8291415a5f3af88850d730d5a381c5656a245ee5b3ad347df9910d9b609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1a95b7f9f88a843bfb7f481b4c53ae33a46738cb919e8857546b58c196e7dc1"
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