class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.23.0.tar.gz"
  sha256 "94cdd17b4b177b9c764548ded24c74e7f4f5360ce60507bb1b5186b2a6cd3cbb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ebb9e9fdb49e30db7fdedbc6e3fe7ccaa744476bb7a7651784c8d16442d58a3"
    sha256 cellar: :any,                 arm64_sonoma:  "26672862a7acbed46168e77ac111dcf295307f058e0d5d0934058651ce96d6b3"
    sha256 cellar: :any,                 arm64_ventura: "d55d661cb188d3ff26182117d7d08ab4c3083469ad4a3504c93c0c086e12a238"
    sha256 cellar: :any,                 sonoma:        "0841ad4e123316f157e09587e95e682bd8004359c2d08c07d7db18c374046206"
    sha256 cellar: :any,                 ventura:       "ccf34357842fa6fffabdf572ef1c20c4682b3b51176e233513c417c27786bc45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6117b85b50f0be17320fd62a4ed2e61495cdba842eac72b5fe7e8275c2053309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f20db1d5c72925bc68e487db20451d2d19dc7ac1fa3556e6a7b74af4408e06"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <stdint.h>
      #include <rere.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}re", "test.c", "-L#{lib}", "-lre"
  end
end