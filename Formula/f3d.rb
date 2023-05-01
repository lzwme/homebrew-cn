class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://ghproxy.com/https://github.com/f3d-app/f3d/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5b335de78a9f68903d7023d947090d4b36fa15b9e165749906a82153e0f56d05"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "375043e50e75bbf477f46bcd1aee256809d55b0760fb837e808586251ad6294c"
    sha256 cellar: :any,                 arm64_monterey: "44edf8af2be7df7b2d68d59f264d5f8fb55c0fef28c9f478f4e32ba20f483e62"
    sha256 cellar: :any,                 arm64_big_sur:  "c52af95dfa27753e917b62dd9c42083b2d354ac7c8c5c9fa981335041d82b348"
    sha256 cellar: :any,                 ventura:        "3f80d0b7942c1a9dad126b5ad4920b51bb9542c0d8783f4544098dae37172e63"
    sha256 cellar: :any,                 monterey:       "53a1b52a358e7c078d02ebc1ae4043ff6e0916897e0baf3075fbbd6784faee62"
    sha256 cellar: :any,                 big_sur:        "4d160a73cb12efb0b77bc2f24fc74b85a529bc126b364020c4d4384ae3f3fae0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43dce6a8e651c86a482d1b60eca81973d0728447ee07a9338834b5b460721e4"
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