class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpp.git",
      tag:      "1.11.390",
      revision: "7e3180c2b820d244ad387aa74f9fcd4a2c0e9892"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a424244b18a27f8ffb436b3522d12f5f3f2747b51be1ea49ab6441f3d5ecb5a6"
    sha256 cellar: :any,                 arm64_sonoma:   "c2a6d824296ad4f8e929296ab82139aa205d9d0ac15bcc3936d94561920eb1bf"
    sha256 cellar: :any,                 arm64_ventura:  "0767deb3747266cd8ad122a4c45c670493278b851ca7bf7626a7950e5536bedc"
    sha256 cellar: :any,                 arm64_monterey: "bc7287fa3fb8e153339d2a49d7e68612ee4e0ef255e51c10922d24759762bc50"
    sha256 cellar: :any,                 sonoma:         "4ff36116d9c2aeaacfd032fa5dff55a93f03ee1ec5907d5bd917bb208819bf45"
    sha256 cellar: :any,                 ventura:        "9e79a4e5879a5d6109dc9c822361af8cfab802685a77dcd4f142d3550f56d5bf"
    sha256 cellar: :any,                 monterey:       "a272bed8f25ff08c8be421551e959741e757fedeaf2a3d3961b13d08805aff22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3ee683c899a154034112da8fbd196973566418741c62d1ab3e6a1ad1c1ebe9"
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