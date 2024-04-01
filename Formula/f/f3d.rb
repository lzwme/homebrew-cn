class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https:f3d-app.github.iof3d"
  url "https:github.comf3d-appf3darchiverefstagsv2.3.1.tar.gz"
  sha256 "e6ada89851cd27c84117b5b73dd69475fa7442f05e1dbf2fa76e1dc34d2c0006"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "283f7c5b83ddec70385d44d61f3f7d7ece9a4cd730494fbd23966f5a463075cf"
    sha256 cellar: :any,                 arm64_ventura:  "dbcf6d88ef6e3e72ba6147972aca0a45835844203602bb0af6b24ad9ffb5ea3c"
    sha256 cellar: :any,                 arm64_monterey: "e10a9852d578848b423596e474fab7fbd7ce6e1c727cf2b3be1d484e36c0f3f6"
    sha256 cellar: :any,                 sonoma:         "d80993f65d5d48a30238fda30cbba9bbd1ac2c5cbb1b1dadc8d93023baa55ee0"
    sha256 cellar: :any,                 ventura:        "d3fe67abef0b77aa304724fedd475d3681c45a9bb019ddea17ac0ea1e7fca065"
    sha256 cellar: :any,                 monterey:       "498fa4ac75f565d374ea16a024d77145aad8b1607f0dbc38cda95b760c9382d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab5dccc7a1176a2dc17fa5abec90984d540018ca93954282be89e0fe405b968"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  # Upstream fix for https:github.comf3d-appf3dissues1087
  patch do
    url "https:github.comf3d-appf3dcommita5ecb6bd.patch?full_index=1"
    sha256 "62856957da64bdf56243c11573b79a624979d9952f64c613c7fe8d5f0ab484dc"
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