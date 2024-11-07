class Libre < Formula
  desc "Toolkit library for asynchronous network IO with protocol stacks"
  homepage "https:github.combaresipre"
  url "https:github.combaresiprearchiverefstagsv3.17.0.tar.gz"
  sha256 "28ee46b097f7b1ff5a73249aacb5a64b742ba9bd5f3321b5c51f41c43233d495"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ef948a7853da77684e15d0678a7a76feeeb4c7f6e3d40a38b53669bee4b93935"
    sha256 cellar: :any,                 arm64_sonoma:  "109d0c52c1cc7d5d9ab82c8844deeb22e82cb6bd0af537172943b042f5f33b88"
    sha256 cellar: :any,                 arm64_ventura: "cf3f8ac2175062cb058f945c8656e31a98537f4d7546219f93b6cb6a5479c424"
    sha256 cellar: :any,                 sonoma:        "a52868b3ba67461793658561a2593f6af5b10bfa316ab80fd4ac18c0809cf3ba"
    sha256 cellar: :any,                 ventura:       "75dc9177b2140f93690d953e086df8cb5fe46f0633d00ffe7872d3f120d81f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b5a2513fe55e5504da44eb33eed57f9a94556694599af462316dab24782f72"
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