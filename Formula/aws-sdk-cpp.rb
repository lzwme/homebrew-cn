class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.120",
      revision: "d32ba7f0eae120ff9667fb333354cf0cce1fd234"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c622acc2c7363ac1cc2284337867c5519f2b0407168a0653386d2471734f0669"
    sha256 cellar: :any,                 arm64_monterey: "ee0abc44f2e200e783bfc8cf1f6fe6fd56a71d3885f6e2e5bdd8cda0b8b7fb18"
    sha256 cellar: :any,                 arm64_big_sur:  "34013ad525640f20ac3dcdae9d668f5ec5435735c3ab39ac9589927108fba6fe"
    sha256 cellar: :any,                 ventura:        "73e02f3926e5c25a93e48d6c148021c25c94e0104092b1294a3e0956d7830599"
    sha256 cellar: :any,                 monterey:       "adf9f8e465924910d9bdc4380428deb7b247d944bc7e3b58cb4cb7e71958b40a"
    sha256 cellar: :any,                 big_sur:        "b80a00a2b59faf9d0aed6aae68cec7218c4918a49342b472e6ba8bd3b21bd14b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c0c93814075a3092bb43bee6c656b053901c1dd489d4ad4164c23667e05362"
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