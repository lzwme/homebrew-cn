class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https:github.comawsaws-sdk-cpp"
  url "https:github.comawsaws-sdk-cpparchiverefstags1.11.525.tar.gz"
  sha256 "ec9c26fdb539f0326a867a2f49a7521d6c96b5e66d0ee08a6da70000cb2798f8"
  license "Apache-2.0"
  head "https:github.comawsaws-sdk-cpp.git", branch: "main"

  livecheck do
    throttle 15
  end

  bottle do
    sha256                               arm64_sequoia: "e62f20112934667967aa08271e4c0ea27db5f2381e0de19f19c545d6aa79a6d4"
    sha256                               arm64_sonoma:  "d244013c5eba11d68a75d872810ecfe3980bb8ae3e4b574d55a3b2f11fe50556"
    sha256                               arm64_ventura: "1022f19514be840980ae70cfd20c755514edf5c4a8860be9a8df7d60539e1cfb"
    sha256 cellar: :any,                 sonoma:        "a2198c4507febe86ff2e91e3882515d0e26b5f8117cf3840c65452c9295e8dd8"
    sha256 cellar: :any,                 ventura:       "e0634398d02f0660f5ea1cecc8d19dfad96be29bfd20cf47ce24e0881c2e9c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d222287f27afb96a3f195bb0da261c9a46f94e0f75125b2c86a8084eeac164b5"
  end

  depends_on "cmake" => :build
  depends_on "aws-c-auth"
  depends_on "aws-c-common"
  depends_on "aws-c-event-stream"
  depends_on "aws-c-http"
  depends_on "aws-c-io"
  depends_on "aws-c-s3"
  depends_on "aws-crt-cpp"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    linker_flags = ["-Wl,-rpath,#{rpath}"]
    # Avoid overlinking to aws-c-* indirect dependencies
    linker_flags << "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DBUILD_DEPS=OFF
      -DCMAKE_MODULE_PATH=#{Formula["aws-c-common"].opt_lib}cmakeaws-c-commonmodules
      -DCMAKE_SHARED_LINKER_FLAGS=#{linker_flags.join(" ")}
      -DENABLE_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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