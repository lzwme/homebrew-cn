class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https://openfast.readthedocs.io"
  url "https://github.com/openfast/openfast.git",
      tag:      "v4.2.1",
      revision: "2daa99a0f9f573642816d6f52c07a2e3b77a85f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b295f67e5403346dbb3201edc351f6d7cb42b8f009b8d32289d6ce67e6d9363"
    sha256 cellar: :any,                 arm64_sequoia: "ef3c569e64e2fa7434ce860d14049bf812183d38d469a4c9c2bed1a4f04aca5b"
    sha256 cellar: :any,                 arm64_sonoma:  "4ea0f3e90275a85defa503e43f2377d1cce3ecc433a6f56289ec4aad90abefae"
    sha256 cellar: :any,                 sonoma:        "c5f83e3a2e0f29ad18ed0b85ba3a31702756dcc56361e66435881a54599bd663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fd69afc4c9184ecf7e3ed13d022745b411e10eb76e9264d6769e6198cb17930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18fe3227898853f6490992b2cd7138a0f0b743d893b595c9805a4a56e3b504a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "openblas"

  def install
    args = %w[
      -DDOUBLE_PRECISION=OFF
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", ".", "--target", "openfast"
    bin.install "glue-codes/openfast/openfast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfast -h")
  end
end