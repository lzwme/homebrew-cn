class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.3.2.tar.gz"
  sha256 "fbcde425a6575f43ac52e9deda87e72b270da5f17b13cafef86c6e80375fd71e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "10760da2e3ab745edfb3e48b21e67fe0fef3b81c58e55495a43dae277bba09e9"
    sha256 cellar: :any, arm64_sequoia: "ae6c9c8a77189eab5e8c1d50cd989a6864ee29193ed0336f673461a164bad013"
    sha256 cellar: :any, arm64_sonoma:  "28281bdb82f3109823f6422bb5bbf0e70cd8deaee4c0ca92c365b19f8bb6a292"
    sha256 cellar: :any, sonoma:        "e216c95c827a57356d4014a2cf77bfc40de305e62894873ef6c403e375450e8e"
    sha256 cellar: :any, arm64_linux:   "5cdf05bddca5b71e62ebdbd4dcc38edc3943af9d5e6995eea7f0c961a4700faf"
    sha256 cellar: :any, x86_64_linux:  "d2fcada539807d6f55a097935ec1d19db41e1756cc3ea96403643e705f73ba5e"
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

  # Apply open PR to fix build with Lua 5.5
  patch do
    url "https://github.com/TACC/Lmod/commit/19625072d1d226c7a63bb36cc73074393a30ae62.patch?full_index=1"
    sha256 "b4ee757b016ad1950dbde17b70a5f3c28c179a9b831b12d51f425670cc8685b1"
    type :unofficial
    resolves "https://github.com/TACC/Lmod/pull/854"
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