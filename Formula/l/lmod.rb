class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.2.8.tar.gz"
  sha256 "9ab4b7e81ed27d0c9e3a5c893b801b7f9de467b7e021231d5a72ee501d22e386"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e856fe6b4140f8ca40c0b530efaec6154f52fedc2273e35899e40a730cd39ff"
    sha256 cellar: :any, arm64_sequoia: "dfc13d5e12b1f8dae58f28098f02aae050b477b66b94660777fce1972febdf39"
    sha256 cellar: :any, arm64_sonoma:  "c12768a625b3e0f6cd6d1129b992963eee7d62906193516c388f9c93a61b10f7"
    sha256 cellar: :any, sonoma:        "ba756ab7c51aa3769f3365cad62cea01edfd866aebb91cd71ffb2738f0bde81f"
    sha256 cellar: :any, arm64_linux:   "93761d1c13e172c696edf16da3cf0800a99bc07bebc0438fd303777b3b9ac89b"
    sha256 cellar: :any, x86_64_linux:  "7452c14d14c3d4731b77cf1bafacc54ccb06b21e05cc765883c9e6fab0457c00"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua@5.4" # due to luaposix
  depends_on "tcl-tk"

  uses_from_macos "bc-gh" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://ghfast.top/https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://ghfast.top/https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  resource "luaposix" do
    url "https://ghfast.top/https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    lua = Formula["lua@5.4"]
    luaversion = lua.version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}", "--lua-dir=#{lua.opt_prefix}"
      end
    end

    # configure overrides PKG_CONFIG_PATH with TCL_PKG_CONFIG_DIR value
    ENV["TCL_PKG_CONFIG_DIR"] = ENV["PKG_CONFIG_PATH"]

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    ENV.deparallelize # Work around "install: mkdir .../share/man: File exists"
    system "make", "install"

    # Remove man page which conflicts with `modules` formula
    rm man1/"module.1"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~SHELL
      #!/bin/sh
      . #{sh_init}
      module list
    SHELL

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end