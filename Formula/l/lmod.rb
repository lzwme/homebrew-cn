class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.53.tar.gz"
  sha256 "5e7ed1a5acfee76abfd96f2ffa3af69d49052b9e88a04ab18d87d18a538c4834"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8674d50fae8017895cc9cf584a1c11218a81e2689e24b9b8e15db2f2052fc7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5399c157970666b639b2cb7f1b44650ba67df8bb01d7f1e0d6c2846ccd22ce69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f71e7caf342970807320d4f49ecaf6d1bfb7dc28a6d53c97625c6c3ac5b87b31"
    sha256 cellar: :any_skip_relocation, sonoma:        "d915829812dd44a79d8bb5442b39b584b04804b47263aeeaa8fb7185029ad0ab"
    sha256 cellar: :any_skip_relocation, ventura:       "c99b2a8027dda56dcf559d3cb642297135fc6585df764f21e52c5f5ea3e86dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "650a593ac759ffdb286de0041a205a384464b8f8f71b3f6af9f116afb73e0701"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "tcl-tk@8" # TCL 9 issue: https:github.comTACCLmodissues728
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