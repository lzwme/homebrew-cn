class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://ghfast.top/https://github.com/f3d-app/f3d/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "f3feeaed716022bc3440b891afbd5eba82a69af7215f66bb9aa72344d7591126"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "72fd6da56af7293967a0e092bd5e9c27bb9b2f9f8fa951c9d97ef032e2306244"
    sha256 cellar: :any,                 arm64_sequoia: "7ed7f6ae1508a1b3c3de5cd001c882d7ceb762904a6928c9d9c1be447b26aacb"
    sha256 cellar: :any,                 arm64_sonoma:  "d18cb3e7b808879ed186db3c3346bb42adc7e0b9cda70d5e7e79cf6f657cd8fb"
    sha256 cellar: :any,                 sonoma:        "dcd9ee303a3fddb96248b90551e371d19f4a3afd879032963e4641e68b636540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69067a2da0330f543a15d5000e8f7b6bde1167f3cd2f8f304d889cf18e3980aa"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  uses_from_macos "zlib"

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
    assert_match "Camera focal point: 0.5, 0.5, 0", f3d_out
  end
end