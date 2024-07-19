class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.45.tar.gz"
  sha256 "239a94a7a5aa3a1ea3b53e686df30f48fe21af7c5be595096f6ba09b77b07001"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a76e7de8a08413473544efa8c5ff3fcf0b06dd9056d303bedf5bb9ec7a5f6fe2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39bb01a9aeef312b1894da24d3c111a294f453bb803a59b28a0074c126cf2ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1270792e4c6d63a52c15eccd3cbe9fd7c5d0e736581cc8162015c9892235b877"
    sha256 cellar: :any_skip_relocation, sonoma:         "2b171c824c2b3062ffb54caf6eadc2dfda5d84c0f61f8904025935837431f5b0"
    sha256 cellar: :any_skip_relocation, ventura:        "74d235f9d2cf62aa175206d9ca74c6268fb106d0f45ce83caabce72554685a02"
    sha256 cellar: :any_skip_relocation, monterey:       "6f8256339da02f9eb8eb6d236daae6ba8d427340cd29c2f19cef725094f233ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f6e25e65922dc1ae6989f21e431547c35cbc57d15e4d568b3127df7bb7b6c69"
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