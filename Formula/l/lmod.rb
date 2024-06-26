class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.43.tar.gz"
  sha256 "d3fc792d9ca4243ef5a3128894b8da40414f06f9b9ea68bc4b37c4ebb90bd41f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef71a5d1449dbac6f4065c7a3f0568f8c9a55ff5ba67e112c9199787bcb40801"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41546faf27b09140619e170ac0500d868ba22633b39f98b595c04e484940988f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2d2bc8517c9b34104fda998ab8d1e3abd3697981933809aa90c3ec1b620e2f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d48d7a4a8598249e03b2d87207192703e16eed041241432cbc96d0ce5200f01d"
    sha256 cellar: :any_skip_relocation, ventura:        "d15fd8c504b39e6fb9b18b4d35b516ba0dbe32cffc9bf684ed0bdb0668adb1a0"
    sha256 cellar: :any_skip_relocation, monterey:       "de7bc1b6c7cb19f624497fbdcb1199e3434ad88a9c0f991295f76c583f575a04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f0b1c6e534cdccdef830995a39b47283bbebb307b2ce15f4309468d3a44ab96"
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