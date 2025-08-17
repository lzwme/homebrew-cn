class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://ghfast.top/https://github.com/f3d-app/f3d/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2a3cff123821be41d99489e080a7153812e58a86598fa9f4988099660bf6a947"
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
    sha256 cellar: :any,                 arm64_sonoma:  "fa73b612a321285ce86719635d65e663c3c3670fd8350f4995f9cea307be4af0"
    sha256 cellar: :any,                 arm64_ventura: "1862dc61d98c3f0aedbb4ab24766a0b69997033ab58a8d9f12d07096259cfb8d"
    sha256 cellar: :any,                 sonoma:        "75702595f0c7de99da89389274dff831a13223d5131a1393e5587e2e9ffe6454"
    sha256 cellar: :any,                 ventura:       "326558254996b510d4a9c0cd9c00ce2c166ec73d639cdb9299d4231a74ec8119"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe22206e260acebdfbf02190ca957c1055aba1bfce9e35f2da098ce85bd20144"
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
    depends_on "libx11"
    depends_on "mesa"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DF3D_MACOS_BUNDLE=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC=ON
      -DF3D_PLUGIN_BUILD_ASSIMP=ON
      -DF3D_PLUGIN_BUILD_OCCT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/f3d --version")

    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading files:.+\n.+obj/, f3d_out)
    assert_match "Camera focal point: 0.5,0.5,0", f3d_out
  end
end