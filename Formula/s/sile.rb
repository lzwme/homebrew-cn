class Sile < Formula
  desc "Modern typesetting system inspired by TeX"
  homepage "https:sile-typesetter.org"
  license "MIT"

  # TODO: With 0.15 release:
  # - Remove `cosmo` resource and corresponding references in install
  # - Switch `lua` dependency to `luajit` and clean up `lua` references
  stable do
    url "https:github.comsile-typesettersilereleasesdownloadv0.14.14sile-0.14.14.tar.xz"
    sha256 "c4671b0f8df27c9e91bbb994ed1f8dc5f2b56179c80f071832307efa070da988"

    depends_on "lua"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "baefbc54429de5bd81cbb63a13fe97ca0b8e2d34a2fbd90baf79197abb670ac7"
    sha256 cellar: :any,                 arm64_ventura:  "143813294a5c61102b15d6dfd3908dee04a41a421a90ef6c8ad79fb201a8c5c9"
    sha256 cellar: :any,                 arm64_monterey: "1670cdc3a38e73e7ff29b0e6da18cf35a77e2f67721dcfa974c1d90de756ed74"
    sha256 cellar: :any,                 sonoma:         "46c5a31697a793eb70dbfcb831040badd3e6b7ad7999c82038372a5c306d51b6"
    sha256 cellar: :any,                 ventura:        "31b4b1f9f04aadc546a7b752e1f8363b6761ebe64581f2f75a94619f5d7018e0"
    sha256 cellar: :any,                 monterey:       "78003e1dc0af0ef27dc21909e420db95f587c16c9b5df3e25756333ea03b5e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4a4014c2a0e1dfa55e156acb1bffd432e683b372cdbfc0ce12db590dddedd48"
  end

  head do
    url "https:github.comsile-typesettersile.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "jq" => :build
    depends_on "libtool" => :build
    depends_on "poppler" => :build
    depends_on "rust" => :build
    depends_on "luajit"

    resource "compat53" do
      url "https:luarocks.orgmanifestslunarmodulescompat53-0.12-1.rockspec"
      sha256 "880cdad8d1789a0756f2023d2c98f36d94e6d2c1cc507190b4f9883420435746"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "libpng"
  depends_on "luarocks"
  depends_on "openssl@3"

  uses_from_macos "unzip" => :build
  uses_from_macos "expat"
  uses_from_macos "zlib"

  resource "linenoise" do
    url "https:luarocks.orgmanifestshoelzrolinenoise-0.9-1.rockspec"
    sha256 "e4f942e0079092993832cf6e78a1f019dad5d8d659b9506692d718d0c0432c72"
  end

  resource "lpeg" do
    url "https:luarocks.orgmanifestsgvvaughanlpeg-1.1.0-1.src.rock"
    sha256 "6637fcf4d3ddef7be490a2f0155bd2dcd053272d1bb78c015498709ef9fa75dd"
  end

  # depends on lpeg
  resource "cosmo" do
    url "https:luarocks.orgmanifestsmascarenhascosmo-16.06.04-1.src.rock"
    sha256 "9c83d50c8b734c0d405f97df9940ddb27578214033fd0e3cfc3e7420c999b9a9"
  end

  resource "loadkit" do
    url "https:luarocks.orgmanifestsleafoloadkit-1.1.0-1.src.rock"
    sha256 "6a631cb08a78324cb5f92b1cb8e2f59502d7113407d0d9b0d95045d8a4febccb"
  end

  resource "lua_cliargs" do
    url "https:luarocks.orgmanifestsamirehlua_cliargs-3.0-2.src.rock"
    sha256 "3c79981292aab72dbfba9eb5c006bb37c5f42ee73d7062b15fdd840c00b70d63"
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
    url "https:luarocks.orgmanifeststieskepenlight-1.13.1-1.src.rock"
    sha256 "fa028f7057cad49cdb84acdd9fe362f090734329ceca8cc6abb2d95d43b91835"
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
    url "https:luarocks.orgmanifestsxavier-wangluautf8-0.1.5-2.src.rock"
    sha256 "68bd8e3c3e20f98fceb9e20d5a7a50168202c22eb45b87eff3247a0608f465ae"
  end

  resource "vstruct" do
    url "https:luarocks.orgmanifestsdeepakjoisvstruct-2.1.1-1.src.rock"
    sha256 "fcfa781a72b9372c37ee20a5863f98e07112a88efea08c8b15631e911bc2b441"
  end

  def install
    if build.head?
      lua = Formula["luajit"]
      luaversion = "5.1"
      luainclude = lua.opt_include"luajit-2.1"
    else
      lua = Formula["lua"]
      luaversion = lua.version.major_minor
      luainclude = lua.opt_include"lua"
    end
    luapath = libexec"vendor"

    paths = %W[
      #{luapath}sharelua#{luaversion}?.lua
      #{luapath}sharelua#{luaversion}?init.lua
      #{luapath}sharelua#{luaversion}lxp?.lua
    ]

    ENV["LUA_PATH"] = paths.join(";")
    ENV["LUA_CPATH"] = "#{luapath}liblua#{luaversion}?.so"

    ENV.prepend "CPPFLAGS", "-I#{luainclude}"
    ENV.prepend "LDFLAGS", "-L#{lua.opt_lib}"

    if OS.mac?
      zlib_dir = expat_dir = "#{MacOS.sdk_path_if_needed}usr"
    else
      zlib_dir = Formula["zlib"].opt_prefix
      expat_dir = Formula["expat"].opt_prefix
    end

    args = %W[
      ZLIB_DIR=#{zlib_dir}
      EXPAT_DIR=#{expat_dir}
      OPENSSL_DIR=#{Formula["openssl@3"].opt_prefix}
      --tree=#{luapath}
      --lua-dir=#{lua.opt_prefix}
    ]

    resources.each do |r|
      # TODO: Remove this line when `cosmo` resource is removed
      next if r.name == "cosmo" && build.head?

      r.stage do
        rock = Pathname.pwd.children(false).first
        unpack_dir = Utils.safe_popen_read("luarocks", "unpack", rock).split("\n")[-2]

        spec = "#{r.name}-#{r.version}.rockspec"
        cd(unpack_dir) { system "luarocks", "make", *args, spec }
      end
    end

    args = %w[
      FCMATCH=true
      --disable-silent-rules
      --with-system-luarocks
    ]
    if build.head?
      args += %w[--with-system-lua-sources --disable-embeded-resources]
      system ".bootstrap.sh"
    end
    system ".configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    env = {
      LUA_PATH:  "#{ENV["LUA_PATH"]};;",
      LUA_CPATH: "#{ENV["LUA_CPATH"]};;",
    }

    (libexec"bin").install bin"sile"
    (bin"sile").write_env_script libexec"binsile", env
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