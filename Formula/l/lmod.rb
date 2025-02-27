class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.57.tar.gz"
  sha256 "9adac555230f0d95cf696619e1a6b19329dd96a304b40c0f7ce85f403965b76a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29a665ce15f7c81543deef159dc435965403740a11cdcc405f54a6aaf92a0943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45b26c9df6f7017de37086a55778f06dea5e9628930630bcccae7ede1bbac9dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7874fc81abad3dc79457f2e6e5d9234e90ae4c092c4ff554de66cc4cdeb19f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f4215399a85c7f6f87734fce11a5bd7aa9b199778f3d20647b697790af7a4e"
    sha256 cellar: :any_skip_relocation, ventura:       "7e523695ee41e4e181b5e51147f87d8a543c809b9089984ee96ff38e73741623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4094908159e99ac0290b70d816820ed3a61a1c8f5aeb465fca6ec1a4e2c0e01d"
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
    url "https:github.comkeplerprojectluafilesystemarchiverefstagsv1_8_0.tar.gz"
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

    # We install `tcl-tk` headers in a subdirectory to avoid conflicts with other formulae.
    ENV.append_to_cflags "-I#{Formula["tcl-tk@8"].opt_include}tcl-tk" if OS.linux?
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