class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.2.7.tar.gz"
  sha256 "baf300e1ab34bbcfad615b2be52a49c6f21c9cf9307748f23643d9e7da0d8b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "eda53acdc522841e8afcb48358775a5097b141eec503fcbfc0639739b4845783"
    sha256 cellar: :any, arm64_sequoia: "e1686ee12edae5c92aa463190eb2d54bae5babd53b0e243b8800404640cc1cda"
    sha256 cellar: :any, arm64_sonoma:  "8f363312eb809d0893ea5aacea4495675da713509a9a558382f12dcbfe40d773"
    sha256 cellar: :any, sonoma:        "700f49937b6dc0e95b41c6c12effc05245b16d266a0e2d482de39a45675b0d3e"
    sha256 cellar: :any, arm64_linux:   "eca5ffb375806111b2e8d66250935456abde66749a1fd1affe64da35ad47f6c9"
    sha256 cellar: :any, x86_64_linux:  "21cc2503be4d625e9e3b178146d3b8594b86fdd2857795188552ab14836c567f"
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