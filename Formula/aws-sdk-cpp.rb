class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.112",
      revision: "ad5a2df5105490284c2abd5c7f1eb4275d8fe8c5"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "00983b1151dc48f7909921cdef6a3ec1b278e8d1c49b2509e272b21695e5e238"
    sha256 cellar: :any,                 arm64_monterey: "6013fab83a6d68bb95d492a7ff30a2ab054f6eb9668d71f52967daec0d460218"
    sha256 cellar: :any,                 arm64_big_sur:  "7f1824b9d24adb8297157e8bb6a9c3fb962416a3038d029c625ee580166416d5"
    sha256 cellar: :any,                 ventura:        "273ca92d338e995331e62c013e2f8be4e506de38d10cadf81aa52cf9039dcaa5"
    sha256 cellar: :any,                 monterey:       "9601d5eb2afe053369c2e8e76c7a35e678ad2a4682b4e80469bf929721bdc02c"
    sha256 cellar: :any,                 big_sur:        "7d17c18ba8dc5513411b6d688222c6b8754701ba7a0eca81304bfa75a68f7b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c6e96220b43a30b6b3ea9db5d8856a0d61da4dfc8c79594fe226a2c64822884"
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