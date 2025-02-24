class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https:f3d-app.github.iof3d"
  url "https:github.comf3d-appf3darchiverefstagsv3.0.0.tar.gz"
  sha256 "7ea83830d1c8158a1f01e5ac9edd00b81de3e0b4cbdbc4a4bb60a113728b7b7a"
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
    sha256 cellar: :any,                 arm64_sonoma:  "7a0ad0c1aadabf3e8fd65ffa4194c3925576cfc6022bcbcd6ea15b08a12dd721"
    sha256 cellar: :any,                 arm64_ventura: "d1b669fa3ef00d76ecbb5e38857bb1246cb50da830c7334cd1f6cbd9875db906"
    sha256 cellar: :any,                 sonoma:        "c8d6a9d85484dbcccda92b771226419fa0ded0fb1564b65c40a13e82cb2ac307"
    sha256 cellar: :any,                 ventura:       "b9a4c94f45572f2a7cd67ae9bd49cb7893341e84b14fec8dd800f4491234569a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbc296c8cfe72eae79d2f0bf12753c3b0fd980df24655451d8caf406a42217c0"
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
    assert_match version.to_s, shell_output("#{bin}f3d --version")

    # create a simple OBJ file with 3 points and 1 triangle
    (testpath"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}f3d --verbose --no-render #{testpath}test.obj 2>&1").strip
    assert_match(Loading files:.+\n.+obj, f3d_out)
    assert_match "Camera focal point: 0.5,0.5,0", f3d_out
  end
end