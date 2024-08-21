class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https:lmod.readthedocs.io"
  url "https:github.comTACCLmodarchiverefstags8.7.48.tar.gz"
  sha256 "3456ee9182ffcfbacbade3568361acf07d10058d3b55beb01e9b7eb5c3e38d27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efd19425f4f8baab432a8f0388bc5d7498efa18611596f26b2403fd1b4034d99"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a53cb20ce09d7dc5b47916ca071f4caa55d5f35e9dd49062aadfbe5628788da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3446b4a34771e0ecabc25ed8566ad5c2c04dd4b3589bbcdbdd74ccb4fd2a6aca"
    sha256 cellar: :any_skip_relocation, sonoma:         "972ae689cef2e0ffe4a4d751ee7a5e1911e9ffcba05ab0d51b9e33b76467606e"
    sha256 cellar: :any_skip_relocation, ventura:        "b94e809a38908f4c399aefd20c7752991f42eed8318ee0c27c92fc14c4de5c88"
    sha256 cellar: :any_skip_relocation, monterey:       "2e07d8b80a191c9b52f7ce011e7f6ec0f1028243a29197cc5a8c5795c1ffc732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b176505c7d56d1160e541d1485e4949c4a1184b74297ee4be44330c91cf89ea6"
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