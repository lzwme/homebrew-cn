class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  # TODO: when 1.11.150 is released, re-throttle this in throttled_formulae.json.
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.147",
      revision: "61ab9c1dc84264a5e0f166895d64cff1a0652a11"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39b5a63af9be30fc6e00d3f32a650587d44f08ab03a5cc92cd9cfcd8901de90a"
    sha256 cellar: :any,                 arm64_monterey: "bb79db02cdc6a087bd5e02504da5ce128f46f1e1de4d31918d7699286bc65bfd"
    sha256 cellar: :any,                 arm64_big_sur:  "7464063586794f671d5e3dca3dc4c8bef76f4056fc0d3370155efc8246ca4a40"
    sha256 cellar: :any,                 ventura:        "6c6be9776c1117b8ce87b8967d0ba6f647f8dffc1c0ea0f4e25f2d2291b692fd"
    sha256 cellar: :any,                 monterey:       "bd57f6e388f2f52e8320d7e2393bef9cbc7e8d83fa67f24b30a026334d8ba16d"
    sha256 cellar: :any,                 big_sur:        "08f09c41235449362ed0a8bdc0c9b69421ed3af2c8c9b51fb6070b386cc04322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd89bafc3185bf245b1887f5de11b2e87656ee750941d69a5eff7194fdec90bd"
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