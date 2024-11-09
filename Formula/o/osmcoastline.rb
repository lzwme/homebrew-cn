class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https:osmcode.orgosmcoastline"
  url "https:github.comosmcodeosmcoastlinearchiverefstagsv2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "605a3249c4abf3290bbb6aace0bb6606581fca5f77ef1d2020132c562e8cb06f"
    sha256 cellar: :any,                 arm64_sonoma:  "396e9a1d22e2b775246004c456bfa26c722a11844fd5a3352c09167d0dd3157c"
    sha256 cellar: :any,                 arm64_ventura: "c40d8ac027bfcf5d2a38d7021d352e37596708a1afe43465dc52b0010e6f8b7e"
    sha256 cellar: :any,                 sonoma:        "36b1d0c5c69680f9fbafd5fbbba294890a148c3d0558dfba796f8f26ab313d27"
    sha256 cellar: :any,                 ventura:       "11ab1852aa52d2baf18133093871584c7e19b12b63f40d2f496da44def050451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cd072c14fc969499f6f7824659012ea476cade804d9e5dff1f9adc4edee014c"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build

  depends_on "expat"
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "bzip2"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  # To fix gdal-3.7.0
  patch do
    url "https:github.comosmcodeosmcoastlinecommit67cc33161069f65e315acae952492ab5ee07af15.patch?full_index=1"
    sha256 "31b89e33b22ccdfe289a5da67480f9791bdd4f410c6a7831f0c1e007c4258e68"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(^llvm(@\d+)?$) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    protozero = Formula["libosmium"].opt_libexec"include"
    args = %W[
      -DPROTOZERO_INCLUDE_DIR=#{protozero}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system bin"osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end