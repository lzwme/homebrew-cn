class EasyrpgPlayer < Formula
  desc "RPG Maker 20002003 games interpreter"
  homepage "https:easyrpg.org"
  url "https:easyrpg.orgdownloadsplayer0.8easyrpg-player-0.8.tar.xz"
  sha256 "06e6d034348d1c52993d0be6b88fc3502a6c7718e366f691401539d5a2195c79"
  license "GPL-3.0-or-later"
  revision 8

  livecheck do
    url "https:easyrpg.orgplayerdownloads"
    regex(href=.*?easyrpg-player[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "91a3f17478db7d87e435ede9a774f9aaa60efd9d1643bd40a1b46d41b6cb583f"
    sha256 cellar: :any,                 arm64_sonoma:  "ee017d61080f9d8f939b265c48baa3a951c639539d7e60fc630a8ea59d75ceef"
    sha256 cellar: :any,                 arm64_ventura: "07a6d81fc75427bb8844e9bd79b6b457def126c37ad2db8e386cf4eb979f5b37"
    sha256 cellar: :any,                 sonoma:        "96816388fdb23de41c554995d0d4b52aa348c50430495d1e6248e425934f3c9f"
    sha256 cellar: :any,                 ventura:       "7d669fe4965e4a7739897bd749ed5f184778d9493eb6e9938135ba23a9058f12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21364ac72fe87a73c520a849792e3ba9b06687a2bb47e28f3cee1d5852fc7895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "900ef138e0241d3b323307182d08e38ae55d1e7f99ca82ec7cbf9e3bbc1c4124"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "speexdsp"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "alsa-lib"
  end

  # Add support for fmt 10
  patch do
    url "https:github.comEasyRPGPlayercommita4672d2e30db4e4918c8f3580236faed3c9d04c1.patch?full_index=1"
    sha256 "026df27331e441116d2b678992d729f9aec3c30b52ffde98089527a5a25c79eb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    if OS.mac?
      prefix.install "buildEasyRPG Player.app"
      bin.write_exec_script prefix"EasyRPG Player.appContentsMacOSEasyRPG Player"
      mv bin"EasyRPG Player", bin"easyrpg-player"
    end
  end

  test do
    assert_match "EasyRPG Player #{version}", shell_output("#{bin}easyrpg-player -v")
  end
end