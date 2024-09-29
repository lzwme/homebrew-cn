class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https:github.comFarama-FoundationArcade-Learning-Environment"
  url "https:github.comFarama-FoundationArcade-Learning-Environmentarchiverefstagsv0.10.1.tar.gz"
  sha256 "7e0473de29b63f59054f8a165a968cf5a168bd9c07444d377a1f70401d268894"
  license "GPL-2.0-only"
  head "https:github.comFarama-FoundationArcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69ba3f3965d52884eb1950417efcf0a5d19a8db48d11aedd12af59fe92e8c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0696c90decbb6dfba17039e5468ec72c4a4cd7b70b0949907420c0ef35760627"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38cd6881049eaf3df3b4e17c76b0af82ef47a8bf4c5bc0f9a41dcddeb183afd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "39f422f6998769392d97cbe6bbbc4af38c9e860d7643c7dc684e0ab4e6bd8818"
    sha256 cellar: :any_skip_relocation, ventura:       "32f6fa20cd2fd7bbadb84681eef5c665aafd5a070f40044d5211dcb34490087c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f2cf58da8b8b441eca30c9f193af76d08137e52926d1c3444a4f8820c8376a2"
  end

  depends_on "cmake" => :build
  depends_on "pybind11" => :build
  depends_on "python-setuptools" => :build
  depends_on macos: :catalina # requires std::filesystem
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "sdl2"

  uses_from_macos "zlib"

  fails_with gcc: "5"

  # See https:github.comFarama-FoundationArcade-Learning-Environmentblobmasterscriptsdownload_unpack_roms.sh
  resource "roms" do
    url "https:gist.githubusercontent.comjjshoots61b22aefce4456920ba99f2c36906edaraw00046ac3403768bfe45857610a3d333b8e35e026Roms.tar.gz.b64"
    sha256 "02ca777c16476a72fa36680a2ba78f24c3ac31b2155033549a5f37a0653117de"
  end

  def python3
    "python3.12"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL_SUPPORT=ON",
                    "-DSDL_DYNLOAD=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "testsresourcestetris.bin"

    # Install ROMs
    resource("roms").stage do
      require "base64"

      pwd = Pathname.pwd
      encoded = (pwd"Roms.tar.gz.b64").read
      (pwd"Roms.tar.gz").write Base64.decode64(encoded)

      system "tar", "-xzf", "Roms.tar.gz"
      (buildpath"srcpythonroms").install pwd.glob("ROM**.bin")
    end

    # error: no member named 'signbit' in the global namespace
    inreplace "setup.py", "cmake_args = [", "\\0\"-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}\"," if OS.mac?
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Replace vendored `libSDL2` with a symlink to our own.
    libsdl2 = Formula["sdl2"].opt_libshared_library("libSDL2")
    vendored_libsdl2_dir = prefixLanguage::Python.site_packages(python3)"ale_py"
    (vendored_libsdl2_dirshared_library("libSDL2")).unlink

    # Use `ln_s` to avoid referencing a Cellar path.
    ln_s libsdl2.relative_path_from(vendored_libsdl2_dir), vendored_libsdl2_dir
  end

  test do
    (testpath"roms.py").write <<~EOS
      from ale_py.roms import get_all_rom_ids
      print(get_all_rom_ids())
    EOS
    assert_match "adventure", shell_output("#{python3} roms.py")

    cp pkgshare"tetris.bin", testpath
    (testpath"test.py").write <<~EOS
      from ale_py import ALEInterface, SDL_SUPPORT
      assert SDL_SUPPORT

      ale = ALEInterface()
      ale.setInt("random_seed", 123)
      ale.loadROM("tetris.bin")
      assert len(ale.getLegalActionSet()) == 18
    EOS

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