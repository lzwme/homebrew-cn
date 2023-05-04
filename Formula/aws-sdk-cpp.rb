class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.70",
      revision: "c795e76a0024301852848b95c180683da0281ff4"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2cb4822f647d4ec424561042d03fff5d12a006569c24b84c78cdd980e238a2a"
    sha256 cellar: :any,                 arm64_monterey: "29b1db356c87f3523ab8b6c230840360743095db118b47972929498fdb3cc954"
    sha256 cellar: :any,                 arm64_big_sur:  "717207c2af440a29c9f66b006c431eb3c94655c3998dea333e04fdbd17725e83"
    sha256 cellar: :any,                 ventura:        "1f47fef1ee572897ced8ab67ca07deb3e766374d391f53dff79d9537584436f9"
    sha256 cellar: :any,                 monterey:       "66a0fb233885617220bfc929e6d3c9370b7d744fa883f156212ab72156a4fdf8"
    sha256 cellar: :any,                 big_sur:        "a6fcd56f9239f54b77b628eac2f84b564a2bdf6150de7ba8e095e89f7f7b9e4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5747d9fab2bbe2368b94abbac020f08cfeb603ee70fb6deb4ee48b984a3a61f2"
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