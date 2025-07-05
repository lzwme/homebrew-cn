class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/8.7.63.tar.gz"
  sha256 "dec0e5e94e36e44f9e3fee36e7dc6fbb4af4e51ab997d45bf59eb1e722ef7727"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c9431a09e29ac9ae6db874045d9f60a5e1362433e8a7f50d3885de4f612c7db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46ccb1c767d9cfcb849ff145591c3aecca03cfde3fe866ebeb401fd3537b1932"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4bef1d1db63040e1409766b605b602fab4a378abc05f54a53c80ec517e4cb34"
    sha256 cellar: :any_skip_relocation, sonoma:        "559fc1a2438671e301a67191baf6af3a6bd670c1477f75a70ab216b1dcf8abbb"
    sha256 cellar: :any_skip_relocation, ventura:       "533fbdf69ee11ccda72de50848eb10ae8ae2d12b387d1c31ef9f3e71a916eb22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4eb4795554809a8f22c44dc47b0bdb880ae828e7362ae80585a6fc43dff589e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff5a7f2f761bcc5fad941642858a69a54c5bc5205af2069c9e51aacd0366b82c"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://ghfast.top/https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://ghfast.top/https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://ghfast.top/https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # pkgconf cannot find tcl-tk on Linux correctly, so we manually set the include and libs
    if OS.linux?
      tcltk_version = Formula["tcl-tk"].version.major_minor
      ENV["TCL_INCLUDE"] = "-I#{Formula["tcl-tk"].opt_include}/tcl-tk"
      ENV["TCL_LIBS"] = "-L#{Formula["tcl-tk"].opt_lib} -ltcl#{tcltk_version} -ltclstub"
      # Homebrew installed tcl-tk library has major_minor version suffix
      inreplace "configure", "'' tcl tcl8.8 tcl8.7 tcl8.6 tcl8.5", "'' tcl#{tcltk_version}"
    end

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
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