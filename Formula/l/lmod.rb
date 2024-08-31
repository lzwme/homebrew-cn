class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.49.tar.gz"
  sha256 "f27877fd73926bb08cab923306d86609e6aaf525fb75842b8035f18ae3e18c5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f42150b9e6671690a5f7ecc86e1abc1fba7947253763737223499d4455c3c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb9b9e4f5a8dacf3d96450ca0eaab4e2fe62ef9455803f5aacb3df0a7a74b8f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2c95e326c0026f5572000bece08d1173cb125c032b46a979a318993ad2325c"
    sha256 cellar: :any_skip_relocation, sonoma:         "91d3e637c6b6c323bc02d451c7d50b17d47a919e947cce7d039d4c6a9466c799"
    sha256 cellar: :any_skip_relocation, ventura:        "dcc5f1eafb33bb9508519bc0284f0211c9af9f604ed969f840474a94f3dc25f2"
    sha256 cellar: :any_skip_relocation, monterey:       "85eb34f4d7fddeb97269a8ac8c193981e6f9382734114d10e93a27695cc9587e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "722d2962220364888f7406212ca734c1d112aa6dfa39d5ccf73b2e6f6461d2f7"
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