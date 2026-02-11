class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.15.0-source.tgz"
  sha256 "abb2632715bd7d0130ded7144fd6263635cd7dea883b8df61ba4da58ce6a1dfe"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?gmsh[._-]v?(\d+(?:\.\d+)+)[._-]source\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8807d1d5d37417122fd66993161a02a28cbc6cd0fe0b49f30ae44aa64f4dbc77"
    sha256 cellar: :any,                 arm64_sequoia: "5609e9c8d652a59724f0d0706a4cc01e9e91122da86f94b26aaf74a1eb682bcc"
    sha256 cellar: :any,                 arm64_sonoma:  "7f4d73af055c6d6bb0ddf314f109cbbe85e2df493361813c106cc812f4a47bdc"
    sha256 cellar: :any,                 sonoma:        "863abbfc1ae158444eb5195caec8af043a6810731b7383ecf853214bc5581ee3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c97abfba2cc654aab332da85b7dacea8502e968d23ee84155fdb31a044545f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6638ce7feabf23f50d02bb5759a5ad11a96f3d2abc369d072a208a71f337efd"
  end

  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "metis"
  depends_on "opencascade"

  on_macos do
    depends_on "freetype"
    depends_on "libomp"
  end

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove some bundled libraries to make sure brew formula is used
    rm_r(%w[
      contrib/eigen
      contrib/metis
    ])

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    args = %w[
      -DENABLE_OS_SPECIFIC_INSTALL=OFF
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
      -DENABLE_SYSTEM_CONTRIB=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Move onelab.py into libexec instead of bin
    libexec.install bin/"onelab.py"
  end

  test do
    system bin/"gmsh", share/"doc/gmsh/examples/simple_geo/tower.geo", "-parse_and_exit"
  end
end