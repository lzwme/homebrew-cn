class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https:f3d-app.github.iof3d"
  url "https:github.comf3d-appf3darchiverefstagsv2.5.1.tar.gz"
  sha256 "55ea01931f90f066df1abc0ae4e9575672e80b83b241f51884224baa8dccac24"
  license "BSD-3-Clause"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "a158b6d659492373c960283233a2434c85594ecb1cd33aef5c28ea5bea55a54b"
    sha256 cellar: :any,                 arm64_ventura: "0e69108d23b6a6286f99e3d60c71347681c2a066c4e445f8e5d5230353e0639e"
    sha256 cellar: :any,                 sonoma:        "7b2a9064eecc991892d9a4d3bf5dbe7cb90c3262ab7b10923194ccd576c4742e"
    sha256 cellar: :any,                 ventura:       "99910851df88d8b03085f336beb523a6a8ad8500904e9f0d356d3716cc070db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfbed537c4b1ff81af941dfb7702cd3dfc6bd4d2e4b7ba67d6881dd6a8a68a95"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "freeimage"
    depends_on "freetype"
    depends_on "glew"
    depends_on "hdf5"
    depends_on "imath"
    depends_on "libaec"
    depends_on "netcdf"
    depends_on "tbb"
    depends_on "tcl-tk@8"
    depends_on "zstd"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC:BOOL=ON
      -DF3D_PLUGIN_BUILD_ASSIMP:BOOL=ON
      -DF3D_PLUGIN_BUILD_OCCT:BOOL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}f3d --verbose --no-render --geometry-only #{testpath}test.obj 2>&1").strip
    assert_match(Loading.+obj, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end