class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.103",
      revision: "811936afbb49ca803f7e9a5c5a8e7509a4a022f9"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a7aeb573806c5aae3138d42b16deb999f715d98cef47976c3031ddc67b5468a3"
    sha256 cellar: :any,                 arm64_monterey: "64fdb16c0c1de0b0c6204a0fdaa5a95bd8c35947ac700b3ff582f1e9779aa6ed"
    sha256 cellar: :any,                 arm64_big_sur:  "fafeb9816ce7df18cde884a9a6a73d864224af7f88eb0391c8b325fdeb0b5645"
    sha256 cellar: :any,                 ventura:        "231a137412a5ff0b186d71b629f9fc9cd6d78819cc89f3aeae3cd08defec16d8"
    sha256 cellar: :any,                 monterey:       "b5a9b2ee9e8e6786a5b7bb780f1d20f541185eeb02d57dd6730d5eb12224c962"
    sha256 cellar: :any,                 big_sur:        "bd3175994b6cf5b9292aab68ab71c104ac121b7cb3d049b2d90b9c455ee3f268"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644085e857dd470b1bf4be9b7cc291a00452ccea8d14a9566a59d16db0a7c063"
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