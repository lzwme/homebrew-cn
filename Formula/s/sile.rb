class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https:sile-typesetter.org"
  license "MIT"
  revision 1

  stable do
    url "https:github.comsile-typesettersilereleasesdownloadv0.15.8sile-0.15.8.tar.zst"
    sha256 "64c17abafd5b1ef30419a81b000998870c1b081b6372d55bc31df9c3b83f0f6a"

    # Needed to workaround upstream source dist snafu, see configure phase
    on_macos do
      depends_on "autoconf" => :build
      depends_on "automake" => :build
      depends_on "libtool" => :build
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "760dcc9aead85503c481ad2c62bc69e81569258a5188ef79115df15fa0359982"
    sha256 cellar: :any,                 arm64_sonoma:  "adf6937d8e83cb00293fe7898a042f43461918cd08a87145fc1623bf6c68ef9c"
    sha256 cellar: :any,                 arm64_ventura: "30a968d237af1c8b46ea79578c6b10ff310ea51fa17b32f5b440d225837f70c0"
    sha256 cellar: :any,                 sonoma:        "87e0fa9b81ff1c67d684d0fcb1c9fc1dafda1b72156928841b9e6f6c5a892b71"
    sha256 cellar: :any,                 ventura:       "501370fa5e9e8222f9e7fd549f4b8b468dec0f06f2e32e11c13ece959aa7cb3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e9ba5802d895353c1e6de168a4668d0893bb908d32272cb9fbe544e6a699859"
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
  depends_on "icu4c@76"
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
    url "https:luarocks.orgmanifestslunarmodulescompat53-0.14.3-1.rockspec"
    sha256 "16218188112c20e9afa9e9057f753d29d7affb10fe3fb2ac74cab17c6de9a030"
  end

  resource "linenoise" do
    url "https:luarocks.orgmanifestshoelzrolinenoise-0.9-1.rockspec"
    sha256 "e4f942e0079092993832cf6e78a1f019dad5d8d659b9506692d718d0c0432c72"
  end

  resource "lpeg" do
    url "https:luarocks.orgmanifestsgvvaughanlpeg-1.1.0-1.src.rock"
    sha256 "6637fcf4d3ddef7be490a2f0155bd2dcd053272d1bb78c015498709ef9fa75dd"
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
    url "https:luarocks.orgmanifestsbrimworkslua-zlib-1.2-2.rockspec"
    sha256 "adc3e279ce67fb477ce7bf88cfb87607491d1c50d9c785b1567066c353f192f9"
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
    url "https:luarocks.orgmanifeststieskepenlight-1.14.0-2.src.rock"
    sha256 "f36affa14fb43e208a59f2e96d214f774b957bcd05d9c07ec52b39eac7f4a05d"
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
    # Work around platform detection results having been baked into the
    # source dist (generated on Linux) with an extra configure cycle to
    # regenerate aminclude.m4 *after* having actually run the platform
    # detection on the target platform and found Darwin.
    if build.stable? && OS.mac?
      system "autoreconf", "-fiv"
      system ".configure", *configure_args, *std_configure_args
    end
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