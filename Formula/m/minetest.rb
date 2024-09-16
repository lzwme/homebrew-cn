class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https:www.minetest.net"
  license "LGPL-2.1-or-later"

  stable do
    url "https:github.comminetestminetestarchiverefstags5.9.1.tar.gz"
    sha256 "aa9a6ae57445b779f57dcba5a83b0704fabd24c5eca37c6c8611e885bdf09d7c"

    resource "irrlichtmt" do
      url "https:github.comminetestirrlichtarchiverefstags1.9.0mt15.tar.gz"
      sha256 "12d24380a19be51cab29f54ae48fe08b327789da9c4d082ff815df60393d643f"
    end

    resource "minetest_game" do
      url "https:github.comminetestminetest_gamearchiverefstags5.8.0.tar.gz"
      sha256 "33a3bb43b08497a0bdb2f49f140a2829e582d5c16c0ad52be1595c803f706912"
    end
  end

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "883006c0b92b264f44b3be436d961c78e9cc1aad2a27e86243c566ea11657a41"
    sha256 cellar: :any, arm64_sonoma:  "356346e62a73c3abd5aa26b938230c5522ee02642a9d91b86c6a8390f761439d"
    sha256 cellar: :any, arm64_ventura: "79169ab7d2226e23bd877dcaac48effc607bcbcccbe9e0c7173f8fc223a7dc19"
    sha256 cellar: :any, sonoma:        "86e5ea34a76d5d73fcb9e429a67ad464f9df73408d39e2e30a8bbeaa4a5afd9e"
    sha256 cellar: :any, ventura:       "89629873d1fea0c717bfc6937574106c6a421e4e376428929c33cdb6cc464ab2"
    sha256               x86_64_linux:  "6708859348bde047c9a966021a741d313c1c43eef7f34234f6dcb153ccdcd110"
  end

  head do
    url "https:github.comminetestminetest.git", branch: "master"

    resource "irrlichtmt" do
      url "https:github.comminetestirrlicht.git", branch: "master"
    end

    resource "minetest_game" do
      url "https:github.comminetestminetest_game.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "jsoncpp"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "luajit"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "ncurses"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxxf86vm"
    depends_on "mesa"
    depends_on "openal-soft"
    depends_on "xinput"
  end

  def install
    # Disable CMake fixup_bundle to prevent copying dylibs into app bundle
    inreplace "srcCMakeLists.txt", "fixup_bundle(", "# \\0"

    # Remove bundled libraries to prevent fallback
    %w[lua gmp jsoncpp].each { |lib| rm_r(buildpath"lib"lib) }

    (buildpath"gamesminetest_game").install resource("minetest_game")
    (buildpath"libirrlichtmt").install resource("irrlichtmt")

    args = %W[
      -DBUILD_CLIENT=1
      -DBUILD_SERVER=0
      -DENABLE_FREETYPE=1
      -DCMAKE_EXE_LINKER_FLAGS='-L#{Formula["freetype"].opt_lib}'
      -DENABLE_GETTEXT=1
      -DCUSTOM_GETTEXT_PATH=#{Formula["gettext"].opt_prefix}
    ]
    # Workaround for 'Could NOT find GettextLib (missing: ICONV_LIBRARY)'
    args << "-DICONV_LIBRARY=#{MacOS.sdk_path}usrliblibiconv.tbd" if OS.mac? && MacOS.version >= :big_sur

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script prefix"minetest.appContentsMacOSminetest" if OS.mac?
  end

  test do
    output = shell_output("#{bin}minetest --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end