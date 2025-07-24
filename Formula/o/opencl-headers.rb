class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://ghfast.top/https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2025.07.22.tar.gz"
  sha256 "98f0a3ea26b4aec051e533cb1750db2998ab8e82eda97269ed6efe66ec94a240"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a77df45da340369c12473f2d7bb2b78ab954ec432c61eabe648434b49785d801"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a77df45da340369c12473f2d7bb2b78ab954ec432c61eabe648434b49785d801"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a77df45da340369c12473f2d7bb2b78ab954ec432c61eabe648434b49785d801"
    sha256 cellar: :any_skip_relocation, sonoma:        "a77df45da340369c12473f2d7bb2b78ab954ec432c61eabe648434b49785d801"
    sha256 cellar: :any_skip_relocation, ventura:       "a77df45da340369c12473f2d7bb2b78ab954ec432c61eabe648434b49785d801"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8b7bef48a5d24c0528a92f1e05ae63ad225852c1d16ebc5c2ef3da1f344668d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8b7bef48a5d24c0528a92f1e05ae63ad225852c1d16ebc5c2ef3da1f344668d"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end