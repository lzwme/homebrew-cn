class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.215",
      revision: "f5fdbfa2a048fe18692667e367e8485fe5ac2814"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b57cb65f2b8eb2035df28485d801db21adddfc150edb6b70c75bb64852e079c7"
    sha256 cellar: :any,                 arm64_ventura:  "953c2c26f3ca9ef8fe1a28dbe4259071bd23bd8b97689583a2f9ac0366cad1f4"
    sha256 cellar: :any,                 arm64_monterey: "ee7a36b0f0cda0c5f3c85126f3612927e66634d138fa2e46d2956f60375b9900"
    sha256 cellar: :any,                 sonoma:         "1a7759223259296df4e136fee99702155b2518c12690c3a48b2dab3c0f04466a"
    sha256 cellar: :any,                 ventura:        "ef30bdc151511729f20b938894ed11615e78aaf0f5511306b9d3004da53b9b42"
    sha256 cellar: :any,                 monterey:       "06c612c5fabe0a54da2dec61123eb8e642593285ce59e5745e7b59c8dbdb2b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bebe9782059f3d52e49aa07b9e6cfe83a03dda80dc7d0100dcdf79641b548fc2"
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