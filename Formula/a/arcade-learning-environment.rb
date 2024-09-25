class ArcadeLearningEnvironment < Formula
  include Language::Python::Virtualenv

  desc "Platform for AI research"
  homepage "https:github.comFarama-FoundationArcade-Learning-Environment"
  url "https:github.comFarama-FoundationArcade-Learning-Environmentarchiverefstagsv0.10.0.tar.gz"
  sha256 "b7cfa312c2c538f4e03e0b308c32f66c335f87b9cd4d495698601063ea9d65b7"
  license "GPL-2.0-only"
  head "https:github.comFarama-FoundationArcade-Learning-Environment.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c85f7f36681ca8b495730c491dfe272ab56227baa3a2b0751d5499764251edc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d00bffd2207730debe347ff06466b3dded6e595c279b7a7be3c900445d2545"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f33a67f675aa6cc418b3f9de04a35ba83e423deeb9dc662946d5b179784b54d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "46307c897806fdcf0ddf6d5d1a7e3710c288dde8bc2d3172463d0a5de176c5d6"
    sha256 cellar: :any_skip_relocation, ventura:       "98da0b96f2b25bbc46d80fe470b91bc5cdfd564dc6554c970153c3f17b20b5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14129b42c2db132cfcf8a25309c349e95241663a247d08e8ce0116eadda6390e"
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