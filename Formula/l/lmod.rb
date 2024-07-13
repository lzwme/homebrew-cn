class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.44.tar.gz"
  sha256 "14d10d5e56fd54c2dba3ca6a144519d601adab16d1f8c96fece8aef5d017dd5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32095703a1120c34338cc7ca4566b06e3c47448bb5f755c70fb26e87bd27105b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6ba9cae113f552d21657d838b1d62c9591edb14268910b963c326e5b2eec9da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0892fd2d1ba3560a2880c4a710a4c722fcc3554aab4065d8d16850d320caddac"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b810db37536c9c9756676e190948678780782a7b4d64f13e42d3ccbc7955a71"
    sha256 cellar: :any_skip_relocation, ventura:        "246d71f44994b3698a1d7847657a69a0d4df2418e656fcff5b55d32edf0f2490"
    sha256 cellar: :any_skip_relocation, monterey:       "baa1e807c214a70a102a0d0679e7479a30b75d38d0d675d9d234a29defe45b51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7316bcf3ea66ba23a2dde84c0f2f1ed63fe36743a688920d8ec168973176795"
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