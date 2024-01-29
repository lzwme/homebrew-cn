class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.250",
      revision: "d1fa2bd0ac80e3b3fdde0e5b3a1f961d3f51f968"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cba994dfa8163df6c7041c8e6e69416f9a2da4a152b523b3026e41ce1b88c60"
    sha256 cellar: :any,                 arm64_ventura:  "f43b0bbd2999c29d4c3f3bf764863cb0aad6f29e464b3ffb70ab366738629ce4"
    sha256 cellar: :any,                 arm64_monterey: "a77da4b6c46a8c677480def586a04b8c86a9c5a7bc3de7d14e91a4c45424e60b"
    sha256 cellar: :any,                 sonoma:         "5f2d80fa47f0798a2b8fbc711009e340d964ee293ca76f54aaca4cc1f6f4d1c1"
    sha256 cellar: :any,                 ventura:        "337ad4d2718324bd03e1040359b9ab580b460c6bdecbe039a44eb3c25af274a2"
    sha256 cellar: :any,                 monterey:       "c297dd2e70a0526e0db644fc8de84619c4cc92cfb46679b1684672b95192273d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16736dd3120552e011a6d552e9ece58963ef7bd4e3d9759d50b8a62f8c088264"
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

    lib.install Dir[lib"macRelease*"].select { |f| File.file? f }
  end

  test do
    (testpath"test.cpp").write <<~EOS
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end