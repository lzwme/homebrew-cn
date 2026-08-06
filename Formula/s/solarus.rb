class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v2.1.1",
      revision: "f411c58a467da28bcea030b420955a26878efb28"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "12b8c37ac45ff8475636134d383efe5b096851c0d6bb0c40fb059802488a899a"
    sha256               arm64_sequoia: "00376d70275c399148a951064049b08a57429e44aab72dafe620a44f5eb71e3a"
    sha256               arm64_sonoma:  "cc623e605775f32cb6eed2fd37400fd5270d2f92fb2dfc2c43e6b57014e78d1b"
    sha256               sonoma:        "229e8be09f8ce6fed05c914655cf2412baeaafaf014bee5fb6c41e944533d455"
    sha256               arm64_linux:   "fc6aaceb1b220be3e19ba2868230aac38d3d696ee3c9f32817774f51aba659c4"
    sha256 cellar: :any, x86_64_linux:  "0051e42c50833337a98057df149119bf9dd2fb20cd698cb4f7e20bba0e9201c4"
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