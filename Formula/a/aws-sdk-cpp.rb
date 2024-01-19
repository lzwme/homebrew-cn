class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.245",
      revision: "9a45f621ff00de1360ce55fdc50a2961b2a23f4b"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af7fc7bab0ae01fb4627883ca8add1497c3a2adc87e1ca5fe8daeaa1ec1f618d"
    sha256 cellar: :any,                 arm64_ventura:  "ae55cbd937e89a1d65c859dea03c3116ac5e370591dbe76b75e0bdc68c344181"
    sha256 cellar: :any,                 arm64_monterey: "77bf15dc71c2679a54a7b2f5123542fcadef92349c753098a0d1cb2ead0fa899"
    sha256 cellar: :any,                 sonoma:         "24b83a18606e6d2d94783e77c5f82a5a3474e74c20bbc76faa8401ece93610bf"
    sha256 cellar: :any,                 ventura:        "7631dfd5793303494f759241aca36b39bd87e59f62c3ea719d78b6e24c36db9f"
    sha256 cellar: :any,                 monterey:       "d1e8b483c947a4efd4ec0b6b34501e0aa9f420eaf4eb9b295d58ea0b61737ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e314e97cb80c8cf890d385fc2e518bad6de8cf45714c8b47314400a20d4a7be9"
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