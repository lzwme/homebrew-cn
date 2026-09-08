class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.3.4.tar.gz"
  sha256 "5e243262f0097e93ab63d2bffa95f322f8155698531d3db099ab88ced728ee19"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "572172dd79523e2bf038714fa7cdfffc6207a106a7e745e95cef800e8b1c1eb0"
    sha256 cellar: :any, arm64_sequoia: "4506aaeba1b560759b43b53775f636595d11aa5626c44784e53f0efcca4154ad"
    sha256 cellar: :any, arm64_sonoma:  "8eea7dffd1392447a3fdaf88899caa60e02aa8be892fa9aaf31c9b4bf8eef476"
    sha256 cellar: :any, arm64_linux:   "ddd08370a4931c3eaff48efb6fe402a0c04c6a4520eba2a157589ba002c8b240"
    sha256 cellar: :any, x86_64_linux:  "d430ea19dc41f5bd4aef2cfdf397ac30f434b626fbc181b138c4b2735077e1ed"
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