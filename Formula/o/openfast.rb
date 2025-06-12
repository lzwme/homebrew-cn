class Openfast < Formula
  desc "NREL-supported OpenFAST whole-turbine simulation code"
  homepage "https:openfast.readthedocs.io"
  url "https:github.comopenfastopenfast.git",
      tag:      "v4.0.5",
      revision: "f4c0b48139479fcfdca10b4dfed6ef86fa1e0d7d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "13b6d12981d1050c198eacd342785c8e6f911c673beb11ed3e68da2f9b450733"
    sha256 cellar: :any,                 arm64_sonoma:  "bb3cbdf4dfd770336c51c4d8c4d4dc97ab67f235594dd96145dd83f9fea8c32e"
    sha256 cellar: :any,                 arm64_ventura: "53274f132b55eefe596a518c08a97883c1d794931d77057fdec46c64228dcb97"
    sha256 cellar: :any,                 sonoma:        "0b5a6f2bad8e6586bc9d71462863b3d4c8fc849f9aa0cfc05defc92dc020b602"
    sha256 cellar: :any,                 ventura:       "e86c66c85984d6c1938d12098e142e698aeba352e337f83ae91ff7eb259881c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2cc9a7b631ecc1d374b251587fcc702dbcdb832ed09d4db9c06580aa89d2255"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa451581abe6c72b25576bf6b9f9f098f7aae25d91d9ae5978002d4293de121"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "netcdf"
  depends_on "openblas"

  def install
    args = %w[
      -DDOUBLE_PRECISION=OFF
      -DBLA_VENDOR=OpenBLAS
    ]

    system "cmake", "-S", ".", "-B", ".", *args, *std_cmake_args
    system "cmake", "--build", ".", "--target", "openfast"
    bin.install "glue-codesopenfastopenfast"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}openfast -h")
  end
end