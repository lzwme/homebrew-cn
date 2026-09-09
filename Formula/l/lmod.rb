class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.4.tar.gz"
  sha256 "83d033a64abb9b921f2e9676e0b2472304f4a7d0512df4b5d1ba79959b6e3823"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5fea85be796f46fa4c1cb83f769ec3fd7d78d5657b7c049a56a00797a04d7c4a"
    sha256 cellar: :any, arm64_sequoia: "f0d16ed0acfd14edbeb76738ea06b15702cad8b88abf0f27239c62b66e902e4f"
    sha256 cellar: :any, arm64_sonoma:  "3d917706bbad24cf23c7b6dd2ccb08fc652b5f9f19892bca8def1aaf2cf994ba"
    sha256 cellar: :any, arm64_linux:   "aa78188ce1a7239725f80e8367dd82a4d3df9cc982cdb81636603e7582b04ff6"
    sha256 cellar: :any, x86_64_linux:  "0de33ffdd0cf6eca55a82b161284b99288fdfdf7e9d8f6f469be821c111724d1"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"
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
    lua = Formula["lua"]
    luaversion = lua.version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        # Arch Linux, Debian and Fedora have packaged luaposix 36.3 for Lua 5.5 without code changes.
        # They don't use luarocks dependency resolver so end up ignoring the Lua constraint.
        # - https://gitlab.archlinux.org/archlinux/packaging/packages/lua-posix/-/commit/bc724ec92dc18e6496593b58561bae8742cd4fd4
        # - https://salsa.debian.org/lua-team/lua-posix/-/commit/b1bd0ec25be0599fbdf7b50fc2442b6874f2e51e
        # - https://src.fedoraproject.org/rpms/lua-posix/c/faa875d881a18fac9b9b277bac4bc72fdeca4624
        #
        # TODO: Remove following when luaposix increases Lua upper bound. Upstream is still
        # waiting on test dependencies: https://github.com/luaposix/luaposix/issues/394
        inreplace "luaposix-36.3-1.rockspec", "'lua >= 5.1, < 5.5'", "'lua >= 5.1, < 5.6'" if r.name == "luaposix"

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