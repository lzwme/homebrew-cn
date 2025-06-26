class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.62.tar.gz"
  sha256 "0f71bd67a629eca1bb5a15aaa98a9e3991f9a702c7ff58433a0e9f51431e96cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81549c19b0b75dfb21f1e624591909f7e2950daddc4ce463a5a135a4e7c568f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30c7b3d9a83506425e802992813af30dacdc2efe916b81c451623d3c303b352b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6a4aa26247f7f5cc59c00e06dde9b6bda4d4efe93a2e26a83c2b6df5e70f7323"
    sha256 cellar: :any_skip_relocation, sonoma:        "1812ff56b60f77dbbe64837d2788a5c1791a2fb0fdaa4bffe00feed9d2a7136b"
    sha256 cellar: :any_skip_relocation, ventura:       "0ecfcb8f61a30a67f6fb7bda1bb1f8b194731e8c41ca0b7fae357a08face64e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1acfb037c9268ce745cb9661c4da50fad728b41a1cc40ef38dd31a0135509c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17a31a0fb1e94e7edd87373abd115c1d637b490c0b441cb9dd0bf315c25dd65f"
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