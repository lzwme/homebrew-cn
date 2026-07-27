class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.1.0",
      revision: "09d45b3c40ab08388eee29e285903e8e3b90a4cc"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "d8bc3ffa9be31e9a3b0426b18c03e65cadcd9cf03defc8ad8505ccb577f47e20"
    sha256               arm64_sequoia: "8020973ff0fbd6656278abbe812c37748c5277161cd61b4af96173793cd8591d"
    sha256               arm64_sonoma:  "d440598e1c7fa9cff1c6529efa241f4263f2fe82d5e4c06171b95e5cc385d5a6"
    sha256               sonoma:        "534f80fe5ec3123566b7c89ab1bba7a008ca2a7b803706c29934eb367b633cc3"
    sha256               arm64_linux:   "5b2cf56bb6a7e2f445ad929ca9dd749c5ecd63583e365d5a8102190cf87ff9bf"
    sha256 cellar: :any, x86_64_linux:  "fc55ee0fc51b5c26af586de7035f80ed4481f0368ac901baedfa5b84432519db"
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit"
  # Upstream only supports OpenAL Soft and not macOS OpenAL.framework
  # https://gitlab.com/solarus-games/solarus/-/blob/dev/cmake/modules/FindOpenAL.cmake?ref_type=heads#L38
  depends_on "openal-soft"
  depends_on "physfs"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DSOLARUS_ARCH=#{Hardware::CPU.arch}",
                    "-DSOLARUS_GUI=OFF",
                    "-DSOLARUS_TESTS=OFF",
                    "-DVORBISFILE_INCLUDE_DIR=#{formula_opt_include("libvorbis")}",
                    "-DOGG_INCLUDE_DIR=#{formula_opt_include("libogg")}",
                    "-DGLM_INCLUDE_DIR=#{formula_opt_include("glm")}",
                    "-DPHYSFS_INCLUDE_DIR=#{formula_opt_include("physfs")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"solarus-run", "-help"
  end
end