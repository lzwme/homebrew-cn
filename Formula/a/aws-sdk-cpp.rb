class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.360",
      revision: "cdc7cd1d0a0962c75e172621003da3a78f743711"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "72d00777941fab3a2c6256370ead1c03203bb4143ee4af4f89a4fef9e30f2838"
    sha256 cellar: :any,                 arm64_ventura:  "c1db28903a01dc8342773d07719a3c690b9c41dd04a26a544c8a6b77535a849e"
    sha256 cellar: :any,                 arm64_monterey: "07c1737ccc011616e5bbdeb05c219c3bf88ce5b73f1e436497623d556b6b6fec"
    sha256 cellar: :any,                 sonoma:         "f3b07e2b62926f0b5fcffc9944dcb4041ec7556b874b7b00105f49b098eabe74"
    sha256 cellar: :any,                 ventura:        "024e5860a0638ac155701ca0a474773e47473684cde29a58d4aef98bb75b0ef5"
    sha256 cellar: :any,                 monterey:       "18fdccb8b34c367a031a9f41ff1a6447acad0309312161a3e2d75291fd2177fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bb700bc366971c3552f9605945d9fe583b4f0a0a1e573c034a66bcf146c5060"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2nunstablecrl.h"

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