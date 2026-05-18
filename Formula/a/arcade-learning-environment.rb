class ArcadeLearningEnvironment < Formula
  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.11.2.tar.gz"
    sha256 "d6ac9406690bb3533b37a99253bdfc59bc27779c5e1b6855c763d0b367bcbf96"

    # Backport fix to run without Gymnasium
    patch do
      url "https://github.com/Farama-Foundation/Arcade-Learning-Environment/commit/237f9c294d2ef95da28f8b74fa3ade54e89fe0c2.patch?full_index=1"
      sha256 "49d70dff3264138c344bb5f5fa10bcce0be8ba75d25ef3d981114ef15f9b30be"
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "030f3a605e34e6b60b10839b1495a7b580db1e64359723caef9e0d74e7779628"
    sha256 cellar: :any,                 arm64_sequoia: "ec092011cc6cc187c51ef2f3f0e1900e26513b803219e565e07dd1d3af81e41a"
    sha256 cellar: :any,                 arm64_sonoma:  "3b2b8f74114e24b713d3916082532bf83d19cf6e5947834c0af5d91720c490fe"
    sha256 cellar: :any,                 sonoma:        "4be81a1eece247bba32478aca5ceabacf37652e9fe55b75c26835dec5bc937bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68785193e0acb8c0cf72098612143bc40b03ff2dba0628108459d5240f4c00db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f54e86c30ee14e86982e9699b2eac0eba2fae8480d03ce23a65b70fb30395a24"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "numpy"
  depends_on "python@3.14"
  depends_on "sdl2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://ghfast.top/https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    version "00046ac3403768bfe45857610a3d333b8e35e026"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Farama-Foundation/Arcade-Learning-Environment/refs/tags/v#{LATEST_VERSION}/scripts/download_unpack_roms.sh"
      regex(%r{/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/(\h+)/Roms\.t}i)
    end
  end

  def python3
    "python3.14"
  end

  def install
    # NOTE: Do not enable vector feature as it uses OpenCV (Apache-2.0) which is incompatible with GPL-2.0-only
    # https://www.gnu.org/licenses/license-list.html#apache2
    # https://www.apache.org/licenses/GPL-compatibility.html
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_VECTOR_LIB=OFF
      -DBUILD_VECTOR_XLA_LIB=OFF
      -DSDL_DYNLOAD=OFF
      -DSDL_SUPPORT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_PYTHON_LIB=OFF", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "tests/resources/tetris.bin"

    # Install ROMs
    resource("roms").stage do
      require "base64"

      pwd = Pathname.pwd
      encoded = (pwd/"Roms.tar.gz.b64").read
      (pwd/"Roms.tar.gz").write Base64.decode64(encoded)

      system "tar", "-xzf", "Roms.tar.gz"
      (buildpath/"src/python/roms").install pwd.glob("ROM/*/*.bin")
    end

    # We build without XLA and jax has no sdists
    inreplace "pyproject.toml", '"jax >= 0.4.31', "#"

    if build.stable?
      inreplace "setup.py", /"-D(BUILD_VECTOR_LIB|BUILD_VECTOR_XLA_LIB|SDL_DYNLOAD)=ON"/, '"-D\1=OFF"'
    else
      cmake_args << "-DCMAKE_INSTALL_RPATH=#{rpath(source: prefix/Language::Python.site_packages(python3)/"ale_py")}"
      ENV["CMAKE_ARGS"] = cmake_args.join(" ")
    end
    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
  end

  test do
    (testpath/"roms.py").write <<~PYTHON
      from ale_py.roms import get_all_rom_ids
      print(get_all_rom_ids())
    PYTHON
    assert_match "adventure", shell_output("#{python3} roms.py")

    cp pkgshare/"tetris.bin", testpath
    (testpath/"test.py").write <<~PYTHON
      from ale_py import ALEInterface, SDL_SUPPORT
      assert SDL_SUPPORT

      ale = ALEInterface()
      ale.setInt("random_seed", 123)
      ale.loadROM("tetris.bin")
      assert len(ale.getLegalActionSet()) == 18
    PYTHON

    output = shell_output("#{python3} test.py 2>&1")
    assert_match <<~EOS, output
      Game console created:
        ROM file:  tetris.bin
        Cart Name: Tetris 2600 (Colin Hughes)
        Cart MD5:  b0e1ee07fbc73493eac5651a52f90f00
    EOS
    assert_match <<~EOS, output
      Running ROM file...
      Random seed is 123
    EOS
  end
end