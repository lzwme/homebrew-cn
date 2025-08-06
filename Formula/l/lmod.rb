class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/8.7.65.tar.gz"
  sha256 "f4650e013dc69183b4990a26f0ab1fdda44ffc787dcd610c7552303103b1a153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b164d43ee500e18db4a6825c4fda3afcec4a2f4853c86b297c7194682060453"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a9c22f9aed882d9afe5c908ce9e470816b53c196fb9f540120dcffad65f7acf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03d9898710ed5f2b0685e3af511a8cd34096c184ee6e186f0c71386954daf764"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a5c1a0da19418f9ebb35ab2f0ebd16e540159049d3cb65e04e899e3467f184d"
    sha256 cellar: :any_skip_relocation, ventura:       "5daf6eedb6fb9d6a9bbb38b748a89804a5d2ae240f52b4653d3ede867e740339"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dcc3fdada7572417c6af563f9ed6c59a98d505f15c1e573d0435e6470fc5966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae7591aac670b9ea9e60e47aa0b663f63dd35378298f41753b4fe46e57f0dd35"
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