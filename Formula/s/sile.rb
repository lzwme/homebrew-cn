class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https:sile-typesetter.org"
  url "https:github.comsile-typesettersilereleasesdownloadv0.15.13sile-0.15.13.tar.zst"
  sha256 "5e97c19651aff710687b93292d5361cb411652094bcc8c62c811c19f7a81464b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "791057d65933cb50c4d8ad27484f2b6d6d838e153de29fc8f95312e7e2785a53"
    sha256 cellar: :any,                 arm64_sonoma:  "47955878faf528c2cb3c9bb91853a58c02e56e6dd00587d2e9d1dd5a3a31dbd7"
    sha256 cellar: :any,                 arm64_ventura: "2947a239426f6aa1aa7db9e14340a18225473a00c1135f5ddead063d9448e202"
    sha256 cellar: :any,                 sonoma:        "9d5cbae91ce3fb80c09381d1236fbbfdc302b62e9a21f179f0b6f3f12f96c680"
    sha256 cellar: :any,                 ventura:       "e2322341d5537d844173bf3e002fc5a91c175e18e5f0519db2f91c28e3806850"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a169fa67dd41e38518571a68c655de8597e5c02fa7f2eea25d8b57876c6cfe29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58dcf197e11ada5600481377945cbd70f41cd3ed5e6ff737a355aa48b19f9215"
  end

  head do
    url "https:github.comsile-typesettersile.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jq" => :build
  depends_on "pkgconf" => :build
  depends_on "poppler" => :build
  depends_on "rust" => :build

  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c@77"
  depends_on "libpng"
  depends_on "luajit"
  depends_on "luarocks"
  depends_on "openssl@3"

  uses_from_macos "unzip" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "freetype"
  end

  resource "compat53" do
    url "https:luarocks.orgmanifestslunarmodulescompat53-0.14.4-1.rockspec"
    sha256 "80b4929c84eae8c00b4bca49a7d049d27d7e89cf3aefeb37cd7dc5f3cc725005"
  end

  resource "linenoise" do
    url "https:luarocks.orgmanifestshoelzrolinenoise-0.9-1.rockspec"
    sha256 "e4f942e0079092993832cf6e78a1f019dad5d8d659b9506692d718d0c0432c72"
  end

  resource "lpeg" do
    url "https:luarocks.orgmanifestsgvvaughanlpeg-1.1.0-2.src.rock"
    sha256 "836d315b920a5cdd62e21786c6c9fad547c4faa131d5583ebca64f0b6595ee76"
  end

  resource "loadkit" do
    url "https:luarocks.orgmanifestsleafoloadkit-1.1.0-1.src.rock"
    sha256 "6a631cb08a78324cb5f92b1cb8e2f59502d7113407d0d9b0d95045d8a4febccb"
  end

  resource "lua_cliargs" do
    url "https:luarocks.orgmanifestslunarmoduleslua_cliargs-3.0.2-1.src.rock"
    sha256 "a2dfbd3f0236eaf4b0421dbd06a631d92b550335eb263b7283e1161a6e90d92e"
  end

  resource "lua-zlib" do
    url "https:luarocks.orgmanifestsbrimworkslua-zlib-1.3-0.rockspec"
    sha256 "8806be122f5621a657078e8038c7c4ff58720aedcb21da8fdd2b01304981b31a"
  end

  # This resource cannot be updated
  # Ref: https:github.comHomebrewhomebrew-corepull128136#issuecomment-1505583956
  resource "luaexpat" do
    url "https:luarocks.orgmanifestslunarmodulesluaexpat-1.4.1-1.src.rock"
    sha256 "b2b31f62fd09252d7ec0218d083cf9b8d9fc6a20f4594559f96649beee172233"
  end

  # depends on lpeg
  resource "luaepnf" do
    url "https:luarocks.orgmanifestssiffiejoeluaepnf-0.3-2.src.rock"
    sha256 "7abbe5888abfa183878751e4010239d799e0dfca6139b717f375c26292876f07"
  end

  resource "luafilesystem" do
    url "https:luarocks.orgmanifestshishamluafilesystem-1.8.0-1.src.rock"
    sha256 "576270a55752894254c2cba0d49d73595d37ec4ea8a75e557fdae7aff80e19cf"
  end

  resource "luarepl" do
    url "https:luarocks.orgmanifestshoelzroluarepl-0.10-1.rockspec"
    sha256 "a3a16e6e5e84eb60e2a5386d3212ab37c472cfe3110d75642de571a29da4ed8b"
  end

  resource "luasocket" do
    url "https:luarocks.orgmanifestslunarmodulesluasocket-3.1.0-1.src.rock"
    sha256 "f4a207f50a3f99ad65def8e29c54ac9aac668b216476f7fae3fae92413398ed2"
  end

  # depends on luasocket
  resource "luasec" do
    url "https:luarocks.orgmanifestsbrunoosluasec-1.3.2-1.src.rock"
    sha256 "f93bf9927bd34a5d4f897f4488b285a12bee89c0e7d54b3b36dfcbf43a7ad4e5"
  end

  # depends on luafilesystem
  resource "penlight" do
    url "https:luarocks.orgmanifeststieskepenlight-1.14.0-3.src.rock"
    sha256 "84e4d23126694a57997d5499490023468190a4b14a64931da61de627ce4fe0c2"
  end

  # depends on penlight
  resource "cldr" do
    url "https:luarocks.orgmanifestsalerquecldr-0.3.0-0.src.rock"
    sha256 "2efc94c10b659ab1009dc191f1694bd332c34379f87f4dd21f827d0e6948ed6d"
  end

  # depends on cldr, luaepnf, penlight
  resource "fluent" do
    url "https:luarocks.orgmanifestsalerquefluent-0.2.0-0.src.rock"
    sha256 "ea915c689dfce2a7ef5551eb3c09d4620bae60a51c20d48d85c14b69bf3f28ba"
  end

  # depends on luafilesystem, penlight
  resource "cassowary" do
    url "https:luarocks.orgmanifestssimoncozenscassowary-2.3.2-1.src.rock"
    sha256 "2d3c3954eeb8b5da1d7b1b56c209ed3ae11d221220967c159f543341917ce726"
  end

  resource "luautf8" do
    url "https:luarocks.orgmanifestsxavier-wangluautf8-0.1.6-1.src.rock"
    sha256 "37901bc127c4afe9f611bba58af7b12eda6599fc270e1706e2f767807dfacd82"
  end

  resource "vstruct" do
    url "https:luarocks.orgmanifestsdeepakjoisvstruct-2.1.1-1.src.rock"
    sha256 "fcfa781a72b9372c37ee20a5863f98e07112a88efea08c8b15631e911bc2b441"
  end

  def install
    lua = Formula["luajit"]
    luaversion = "5.1"
    luapath = libexec"vendor"

    paths = %W[
      #{luapath}sharelua#{luaversion}?.lua
      #{luapath}sharelua#{luaversion}?init.lua
      #{luapath}sharelua#{luaversion}lxp?.lua
    ]

    ENV["LUA_PATH"] = "#{paths.join(";")};;"
    ENV["LUA_CPATH"] = "#{luapath}liblua#{luaversion}?.so;;"

    ENV.prepend "CPPFLAGS", "-I#{lua.opt_include}luajit-2.1"
    ENV.prepend "LDFLAGS", "-L#{lua.opt_lib}"

    if OS.mac?
      zlib_dir = expat_dir = "#{MacOS.sdk_path_if_needed}usr"
    else
      zlib_dir = Formula["zlib"].opt_prefix
      expat_dir = Formula["expat"].opt_prefix
    end

    luarocks_args = %W[
      ZLIB_DIR=#{zlib_dir}
      EXPAT_DIR=#{expat_dir}
      OPENSSL_DIR=#{Formula["openssl@3"].opt_prefix}
      --tree=#{luapath}
      --lua-dir=#{lua.opt_prefix}
    ]

    resources.each do |r|
      r.stage do
        rock = Pathname.pwd.children(false).first
        unpack_dir = Utils.safe_popen_read("luarocks", "unpack", rock).split("\n")[-2]
        spec = "#{r.name}-#{r.version}.rockspec"
        cd(unpack_dir) { system "luarocks", "make", *luarocks_args, spec }
      end
    end

    configure_args = %w[
      FCMATCH=true
      --disable-silent-rules
      --disable-static
      --disable-embeded-resources
      --with-system-lua-sources
      --with-system-luarocks
      --with-vendored-luarocks-dir=#{luapath}
    ]

    system ".bootstrap.sh" if build.head?
    system ".configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      By default SILE uses the font Gentium Plus to render all documents that do not specifically call for something else. If this font is not available on your system you may encounter errors. Of lower priority depending on your use case, the math typesetting package defaults to using Libertinus Math and the default monospace font is Hack.

      Homebrew does not supply any of these font dependencies in default casks, but they can be added by tapping cask-fonts:
        brew tap homebrewcask-fonts
        brew install --cask font-gentium-plus
        brew install --cask font-libertinus
        brew install --cask font-hack

      Alternatively you can download and install the fonts yourself:
        https:software.sil.orggentium
        https:github.comalerquelibertinus
        https:sourcefoundry.orghack
    EOS
  end

  test do
    assert_match "SILE #{version.to_s.match(\d\.\d\.\d)}", shell_output("#{bin}sile --version")
  end
end