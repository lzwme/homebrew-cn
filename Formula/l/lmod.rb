class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.42.tar.gz"
  sha256 "290867693a0d78d40ea5aed4172951dd1c7636d47a3695abcd53c71ed17a513b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e7d60f0c41ca4bb9b7f8ae89f03a90bfee1566c8f29ee043480bb666edd0dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2265e04843d46389d62b5581fdd371f10f585e747f8304cefe5f45f84a07dcdf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a47464dfd2d2fa462e783cb0287716ea288271d66ea6039075b98ea4f613765"
    sha256 cellar: :any_skip_relocation, sonoma:         "84dad22fd1e1a223c604a190ceace56d81b700a15f1d5d5117c6c1361c6e6e35"
    sha256 cellar: :any_skip_relocation, ventura:        "a223b3456b930acab8e45e48fee2c5a1af49525c1148758008ed96440a3bfd94"
    sha256 cellar: :any_skip_relocation, monterey:       "2b74fd5eea340b56b356912a79c53c32c31b8b35fdf0320ee6ccd7b66c6525a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5008e5af87cc69989642b9e9668ad7faeee0d99e3fcf4c7e819c991fa6d5fc0e"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gnu-sed" => :build
  end

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