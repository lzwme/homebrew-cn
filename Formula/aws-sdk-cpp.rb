class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.125",
      revision: "6cc48868b7558265fd095ce338ce37320a2968e2"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "20ae97b761421fc095760cadde72145da9991c5d573904ebffccbbbb582ddc31"
    sha256 cellar: :any,                 arm64_monterey: "b912e01c7bd8a87c8d2fd09d903c17f47fd60bd84fd6277aed8103119de55dab"
    sha256 cellar: :any,                 arm64_big_sur:  "3b523bcb386a4647592f5a29a87734251b7efd0bdfda41b2a38e82ac407d8a89"
    sha256 cellar: :any,                 ventura:        "fe42350b9d6f108c06644d7cca8438389d80c72fb38d9c2b07f2111d4109e464"
    sha256 cellar: :any,                 monterey:       "4767a63d18d7318a02c440f117d81f898fc5e3a97e7d92260132afcab5e3f448"
    sha256 cellar: :any,                 big_sur:        "81d3331d18e4ed284ecb176c3b9443795fbcea08577c9084024c7c1acaa2ebc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aefa1d9f57ba171e1c83eee8d8a018a0ef842964779c91ed2fba9ca53a36c64"
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