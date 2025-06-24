class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.61.tar.gz"
  sha256 "bbe5963f96de3cd5c51f4bdf9cf0c7633fd2db9cdd06478670ce61e1139422e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "252557fcffbed9658b7bca14b6fd52b09ddadba6186b54f5f6dbe9fa94bdc397"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f7c974d876002b48ee77125318adabd19f0b1221369f0e894749794460b203"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b597f13a913d04aedfb8b53d31b94b9976b0686d217c0e07377aad9eb3606584"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cb2e4a53d0fa2d00cbc4fddec9086c7b67e619ec4d9b903aad3c097bfc40d1c"
    sha256 cellar: :any_skip_relocation, ventura:       "e5bdc4468bb2048bdecf2cfb6b8eb9e249a4753332014574787ada5f19919512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cc6dac9d2213b53b86d4f309a4844991d9637676d3c7c30ca7013e80d89a135"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1d645e9af27956cc6c0e662407c2babf62ba49dc243550a060b8d066b2a3122"
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
    url "https:github.comhoelzrolua-termarchiverefstags0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https:github.comlunarmodulesluafilesystemarchiverefstagsv1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https:github.comluaposixluaposixarchiverefstagsv36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}sharelua#{luaversion}?.lua;" \
                      "#{luapath}sharelua#{luaversion}?init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}liblua#{luaversion}?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # pkgconf cannot find tcl-tk on Linux correctly, so we manually set the include and libs
    if OS.linux?
      tcltk_version = Formula["tcl-tk"].version.major_minor
      ENV["TCL_INCLUDE"] = "-I#{Formula["tcl-tk"].opt_include}tcl-tk"
      ENV["TCL_LIBS"] = "-L#{Formula["tcl-tk"].opt_lib} -ltcl#{tcltk_version} -ltclstub"
      # Homebrew installed tcl-tk library has major_minor version suffix
      inreplace "configure", "'' tcl tcl8.8 tcl8.7 tcl8.6 tcl8.5", "'' tcl#{tcltk_version}"
    end

    system ".configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"

    # Remove man page which conflicts with `modules` formula
    rm man1"module.1"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}initprofile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}initfish, such as:
        ln -s #{opt_prefix}initfish ~.configfishconf.d00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}initsh"

    (testpath"lmodtest.sh").write <<~SHELL
      #!binsh
      . #{sh_init}
      module list
    SHELL

    assert_match "No modules loaded", shell_output("sh #{testpath}lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}libexecspider #{prefix}modulefilesCore")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end