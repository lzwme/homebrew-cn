class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.33.tar.gz"
  sha256 "181d6fbc7486cdbef2c1f6aaa373f781deb262c0d44cbbd5aa4d1f532c3f21b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "889ea8ddc046a3b86ac853200a32349f19d3d748ab65e3278782e0796b6f9b89"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cacf2295d4a14e93fb842ad85965bcc811f77d63203269a4dbecb7684796eaf9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bab3908c138119278abc9600fbbb016fc062e0485e8eb6fef7e6071946ebdf8"
    sha256 cellar: :any_skip_relocation, sonoma:         "542eceffb2cfa9c02bf7a7aa6240ff652376835a6e0edf29edea258e6a23c547"
    sha256 cellar: :any_skip_relocation, ventura:        "8d3ce19debd2424f2d68c67740add04e35a47a4073312a2aff67571a0173e3c5"
    sha256 cellar: :any_skip_relocation, monterey:       "5957a674a67f33ca4ce86cf5b544a555716a4c0b0924319d534744187a56143c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5ef680912324a8bceb4297a66f038b2408345aa0a5f5970c0892975a02996c8"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https:github.comkeplerprojectluafilesystemarchiverefstagsv1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https:github.comluaposixluaposixarchiverefstagsv36.2.1.tar.gz"
    sha256 "44e5087cd3c47058f9934b90c0017e4cf870b71619f99707dd433074622debb1"
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
    ENV.append_to_cflags "-I#{Formula["tcl-tk"].opt_include}tcl-tk" if OS.linux?
    system ".configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
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

    (testpath"lmodtest.sh").write <<~EOS
      #!binsh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}libexecspider #{prefix}modulefilesCore")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end