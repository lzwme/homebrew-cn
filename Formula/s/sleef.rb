class Sleef < Formula
  desc "SIMD library for evaluating elementary functions"
  homepage "https:sleef.org"
  url "https:github.comshibatchsleefarchiverefstags3.6.1.tar.gz"
  sha256 "441dcf98c0f22e5d5e553d007f3b93e89eb58e4c66e340da8af5e7f67d1dc24c"
  license "BSL-1.0"
  revision 1
  head "https:github.comshibatchsleef.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1b0ea11328c3aedfdb2a7fb51fef6e6293fe718afdf37060f6ee459daede4fcb"
    sha256 cellar: :any,                 arm64_sonoma:   "58dac621386569ca8890a32919d856130bbcb7ece80e488c830c75c850dc91db"
    sha256 cellar: :any,                 arm64_ventura:  "a8bb4e3f93058e42b93cb262aa8ad3f2cd89b2c51f8eb356c65751353546f989"
    sha256 cellar: :any,                 arm64_monterey: "f4894c52025eb79156b03c2f3bdc6bc1472552bf38e7265fd0cd7fc7efc7e64b"
    sha256 cellar: :any,                 sonoma:         "2df97f4bd348a0e5ac9d3ff58ccedf7e69f76c7331de73cb32379554b923f8fb"
    sha256 cellar: :any,                 ventura:        "3baff7e2fe8c80e382d20ef465f711ffff99f19ae84071348a9b11bdbabf90b3"
    sha256 cellar: :any,                 monterey:       "5f832edda361b8452e5500f229b7715d27d51fd14f0b0eda07bfa9c849999315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19497fd48ec12e5753c6c76b3def0297620144abe1518c880ca5673ad18084d0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSLEEF_BUILD_INLINE_HEADERS=TRUE",
                    "-DSLEEF_BUILD_SHARED_LIBS=ON",
                    "-DSLEEF_BUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <stdio.h>
      #include <math.h>
      #include <sleef.h>

      int main() {
          double a = M_PI  6;
          printf("%.3f\\n", Sleef_sin_u10(a));
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lsleef"
    assert_equal "0.500\n", shell_output(".test")
  end
end