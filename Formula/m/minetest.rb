class Minetest < Formula
  desc "Free, open source voxel game engine and game"
  homepage "https:www.minetest.net"
  license "LGPL-2.1-or-later"

  stable do
    url "https:github.comminetestminetestarchiverefstags5.11.0.tar.gz"
    sha256 "70e531d0776988ce6e579ea5490fdf6be3e349a4ade5281f5111aa4fdd8ee510"

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
    sha256 cellar: :any, arm64_sequoia: "9ff03cc17ac3b53b2f7715298ed614e4b02157ae6d6cd2a9a6d7a10d08d38644"
    sha256 cellar: :any, arm64_sonoma:  "3583b7f63bc30c3ddb8d63ff21cbf92533af3e64f98949946bae0169d27477f6"
    sha256 cellar: :any, arm64_ventura: "6bad098cf55692d28cfb1b08a99ab8d8ccd38ceb9f0abbacbbc2356d48031143"
    sha256 cellar: :any, sonoma:        "76e0b80ebb30a408fab7184f2122a693432e71af40949f85d73838454f431f71"
    sha256 cellar: :any, ventura:       "6905ae40165af014ebb852e26a13b87a6f90ff5fe5a898744fc7ea18cc796756"
    sha256               x86_64_linux:  "4b08c9839555bdfd8cf5d515eb33cecabdc1f864dc5c094750ec6fad3adb3f5e"
  end

  head do
    url "https:github.comminetestminetest.git", branch: "master"

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

    bin.write_exec_script prefix"luanti.appContentsMacOSluanti" if OS.mac?
  end

  test do
    # engine got changed from minetest to luanti with 5.10.0 release
    output = shell_output("#{bin}luanti --version")
    assert_match "USE_CURL=1", output
    assert_match "USE_GETTEXT=1", output
    assert_match "USE_SOUND=1", output
  end
end