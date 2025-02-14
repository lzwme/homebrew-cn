class Cglm < Formula
  desc "Optimized OpenGLGraphics Math (glm) for C"
  homepage "https:github.comrecpcglm"
  url "https:github.comrecpcglmarchiverefstagsv0.9.5.tar.gz"
  sha256 "1e40e87bc934ba8567ef84484d31d5d64ca084d3f0a7523ec67988bc94d76435"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4724a513eae03317bebeb2e0032e1d1b67b1ab2fc1798f24974f86a68a4c2190"
    sha256 cellar: :any,                 arm64_sonoma:  "6d32234b10c2897e67e61c582e4839720852e53678b74841b69862f15af7edb2"
    sha256 cellar: :any,                 arm64_ventura: "85beb3f46156f507f4e40e251a4df3497c2fcb072469da56287027a5b59241c2"
    sha256 cellar: :any,                 sonoma:        "f53d89482d4b21c22851a1c52c691bc6abf4160196c2116dd1b128a1bb94b24c"
    sha256 cellar: :any,                 ventura:       "2e68e38ad9cc1fc5964955ea76e35865a2fd7879e8a3cb67aa909d26cfe700bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9941e1474328c6fae09a7e8dfdec4316f0a061c020e5e1a5499767924621fd4b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath"test.c").write <<~C
      #include <cglmcglm.h>
      #include <assert.h>

      int main() {
        vec3 x = {1.0f, 0.0f, 0.0f},
             y = {0.0f, 1.0f, 0.0f},
             z = {0.0f, 0.0f, 1.0f};
        vec3 r;

        glm_cross(x, y, r);
        assert(glm_vec3_eqv_eps(r, z));
        return 0;
      }
    C
    system ENV.cc, "-I#{include}", testpath"test.c", "-o", "test"
    system ".test"
  end
end