class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https://github.com/Farama-Foundation/Arcade-Learning-Environment"
  url "https://ghfast.top/https://github.com/Farama-Foundation/Arcade-Learning-Environment/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "2b878ae1b7febb498c7ab5351791c6d9838dc214b4825eec0df1b53b58b6aaa3"
  license "GPL-2.0-only"
  head "https://github.com/Farama-Foundation/Arcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "8d87d2e4b11ba564c543865131922e5c1dff39a4e435b6131de0457dd22cae2c"
    sha256 cellar: :any,                 arm64_ventura: "95950e96cce466d33d976383da6074fbe79edc88e1b4510c80eb3477821e7907"
    sha256 cellar: :any,                 sonoma:        "b44653d20e65755dee7012979796e55627f91364cb7c64354498ffdf1829eb0d"
    sha256 cellar: :any,                 ventura:       "29c3bd51a8760f8b9aca78895128398104a088fec43d5af6c12a08e66716eaa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d152b9cf2c6106dfc85851479e7218cee002053d30b36a5c528e14ecba8ffd73"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pybind11" => :build
  depends_on "python-packaging" => :build
  depends_on "python-setuptools" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "opencv"
  depends_on "python@3.13"
  depends_on "sdl2"

  uses_from_macos "zlib"

  # See https://github.com/Farama-Foundation/Arcade-Learning-Environment/blob/master/scripts/download_unpack_roms.sh
  resource "roms" do
    url "https://ghfast.top/https://gist.githubusercontent.com/jjshoots/61b22aefce4456920ba99f2c36906eda/raw/00046ac3403768bfe45857610a3d333b8e35e026/Roms.tar.gz.b64"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"
  end

  resource "gymnasium" do
    url "https://files.pythonhosted.org/packages/90/69/70cd29e9fc4953d013b15981ee71d4c9ef4d8b2183e6ef2fe89756746dce/gymnasium-1.1.1.tar.gz"
    sha256 "8bd9ea9bdef32c950a444ff36afc785e1d81051ec32d30435058953c20d2456d"
  end

  def python3
    "python3.13"
  end

  def install
    resource("gymnasium").stage do
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON",
                    *std_cmake_args
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

    inreplace "setup.py" do |s|
      # error: no member named 'signbit' in the global namespace
      s.gsub! "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?
      # Remove XLA support for now
      s.gsub! "-DBUILD_VECTOR_XLA_LIB=ON", ""
    end
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Replace vendored `libSDL2` with a symlink to our own.
    libsdl2 = Formula["sdl2"].opt_lib/shared_library("libSDL2")
    vendored_libsdl2_dir = prefix/Language::Python.site_packages(python3)/"ale_py"
    (vendored_libsdl2_dir/shared_library("libSDL2")).unlink

    # Use `ln_s` to avoid referencing a Cellar path.
    ln_s libsdl2.relative_path_from(vendored_libsdl2_dir), vendored_libsdl2_dir
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