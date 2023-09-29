class Nest < Formula
  desc "Neural Simulation Tool (NEST) with Python3 bindings (PyNEST)"
  homepage "https://www.nest-simulator.org/"
  url "https://ghproxy.com/https://github.com/nest/nest-simulator/archive/v3.6.tar.gz"
  sha256 "68d6b11791e1284dc94fef35d84c08dd7a11322c0f1e1fc9b39c5e6882284922"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "491d753a19d608828cfbcaa672bc223232f0f7550609a4c347331380cf547ef6"
    sha256                               arm64_ventura:  "d0c7bb6698d3c42d5994ad305dfea425bddad209ac0d04718c38546f2ec99a82"
    sha256                               arm64_monterey: "9af105814cf8c51fece1054f1a51c79c7751846491c193229a5c256f86652331"
    sha256                               sonoma:         "f3405630f59949c8843b3d52f99f8645904c4ed854e8ecd09d220938843de98e"
    sha256                               ventura:        "f6dbb779ce41bb0f6d41c52a3b6be58e3c9f6fff00693f84cfe294225298748c"
    sha256                               monterey:       "c6f9123210f14941cb5d79bd6943c4bda91957173c5fb2c23af53a72c6d99647"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db898f6801b9e9cf017fd81dcfd6c7090a89af2447976e8dcd20d8d2b99d182a"
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build
  depends_on "gsl"
  depends_on "libtool"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "readline"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libomp"
  end

  def install
    # Help FindReadline find macOS system ncurses library
    sdk = MacOS.sdk_path_if_needed
    args = sdk ? ["-DNCURSES_LIBRARY=#{sdk}/usr/lib/libncurses.tbd"] : []

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Replace internally accessible gcc with externally accessible version
    # in nest-config if required
    inreplace bin/"nest-config", Superenv.shims_path/ENV.cxx, ENV.cxx
  end

  def caveats
    <<~EOS
      The PyNEST bindings and its dependencies are installed with the python@3.11 formula.
      If you want to use PyNEST, use the Python interpreter from this path:

          #{Formula["python@3.11"].bin}

      You may want to add this to your PATH.
    EOS
  end

  test do
    # check whether NEST was compiled & linked
    system bin/"nest", "--version"

    # check whether NEST is importable form python
    system Formula["python@3.11"].bin/"python3.11", "-c", "'import nest'"
  end
end