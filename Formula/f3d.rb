class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://ghproxy.com/https://github.com/f3d-app/f3d/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5b335de78a9f68903d7023d947090d4b36fa15b9e165749906a82153e0f56d05"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f7d0bfb9765ad1156b7996039407af69525bdd1fb73a309d77684bcd6754ed5c"
    sha256 cellar: :any,                 arm64_monterey: "540d689c5486a0e9a7a7afd4acfcdece8eba55b4ba96ab829e2e7adb6025ccdc"
    sha256 cellar: :any,                 arm64_big_sur:  "ac7a7db97e832ca67f6936f7f1a5539cf189d10e120054188ca03405c29a3a60"
    sha256 cellar: :any,                 ventura:        "03d7eead2c76a35c4d469d21f2dbc85f7705b39e54b201ff452e0873fd761f56"
    sha256 cellar: :any,                 monterey:       "7a3ecefbbb8c9a9ac43dceec33da82fe1f2ce421606485f01f6425927a4c8592"
    sha256 cellar: :any,                 big_sur:        "a0d12b71c0b4dc5f389449aedfdefca19eb61082a085ce9d1ba599dc70742f9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "509e5e220527dc1af091f5165226c31f20a17767cc1a2bef3a87ffad5762f559"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

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
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end