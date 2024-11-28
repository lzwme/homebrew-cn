class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.450",
      revision: "c808a26c2141f0e5be2f830b4a74ad73ec86fb2d"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "692c0415ce1f4b6042e7eda6df561e84bb0846c16d6f327bd4dda24a9bdc132d"
    sha256 cellar: :any,                 arm64_sonoma:  "412470660fb2aded240a852204d85f3f89f1f222a1af50bb997fef8903b09575"
    sha256 cellar: :any,                 arm64_ventura: "d5ae47fbadcd6c5ee1dd051aad05a6768ecbc2639b1c8e920308f304129ce169"
    sha256 cellar: :any,                 sonoma:        "a517b0c2c3c48f5dd1258f96d822d969cc264eff4f77011a83becdd5bde0f00d"
    sha256 cellar: :any,                 ventura:       "b37f8655d3d60b0798c85bef74198ac295b8e6cb983f5b43e14014b7f47987bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f568507b2fe726173cc2b87e84d535da4ac2b7d9678f99d1815295027b481e"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with "s2n", because: "both install s2nunstablecrl.h"

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
    (testpath"test.cpp").write <<~CPP
      #include <awscoreVersion.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system ".test"
  end
end