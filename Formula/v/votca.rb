class Votca < Formula
  desc "Versatile Object-oriented Toolkit for Coarse-graining Applications"
  homepage "https://www.votca.org/"
  url "https://ghfast.top/https://github.com/votca/votca/archive/refs/tags/v2025.1.tar.gz"
  sha256 "85b487d2b2a31f26869be422c98f816b95c88a4ab112ea4650cccd4c2706bdbf"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "72a7e979c09e507ffd4e176f4804b8edd351d7f3530747e0acf2b5c4fe3fd71f"
    sha256 cellar: :any,                 arm64_sequoia: "b7d2c9c5455447bbe46b1f76c6d6aa0f45fec3fea090271eb4f9ca92679a9d6b"
    sha256 cellar: :any,                 arm64_sonoma:  "8d05fa695814e71319f9078d4ad488e7f7e77768fc231be3c711104fec726313"
    sha256 cellar: :any,                 sonoma:        "cf6fbd2feda356e3d7ff6e54759e23bd0316bd5dd1f01f4eabfe06cc9cb80154"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bfd361e34b774e8075310e994bbdac0c21baf1a8881df5bb1d071de9636ac84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e9ae1f533a07865cc299655e7ea5442b7553f0d97dc9b8fab961fffa47cfe0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "fftw"
  # add gromacs dep back once it was built with clang
  depends_on "hdf5"
  depends_on "libecpint"
  depends_on "libint"
  depends_on "libxc"

  uses_from_macos "expat"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = [
      "-DINSTALL_RC_FILES=OFF",
      "-DINSTALL_CSGAPPS=ON",
      "-DBUILD_XTP=ON",
      "-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=ON",
      "-DENABLE_RPATH_INJECT=ON",
      "-DPYrdkit_FOUND=OFF",
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"csg_property", "--help"
    (testpath/"table.in").write <<~EOS
      0 0 i
      1 1 i
    EOS
    system bin/"csg_resample", "--in", "table.in", "--out", "table.out", "--grid", "0:0.1:1", "--type", "linear"
    assert_path_exists "#{testpath}/table.out"
  end
end