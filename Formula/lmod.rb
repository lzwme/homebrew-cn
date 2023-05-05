class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.24.tar.gz"
  sha256 "8451267652059b6507b652e1b563929ecf9b689ffb20830642085eb6a55bd539"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8dae24c319faceacb8a65f35b1c7473db2e7cad21e3080e0bbc70bfbcc588b14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e403c0c64b28fac36aeed6b208474e2c3f853dff0bc9dfdc42b3a3746241e57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ffa57144ff3bb9ed206084d0ba63fceca953afb8278be426433a7faf251af1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c96f3087fa6be3a2364b2d0e31fd00cc53af76f88a26bf33e8b233e445c1627"
    sha256 cellar: :any_skip_relocation, monterey:       "d965c95cb392dea0b9a0424fb7db1a725a5866fbbcd4ade9c854e2aca9b9f89c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ffa637a61be8ef548c1ec752a4e34038c26264749e9c4f634836fcd28fb076c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0514bd24c23fa05fb0570869553eef1314c6d2312d5b6bff62db7b6fcebacf77"
  end

  depends_on "luarocks" => :build
  depends_on "pkg-config" => :build
  depends_on "lua"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"
  uses_from_macos "tcl-tk"

  resource "luafilesystem" do
    url "https://ghproxy.com/https://github.com/keplerproject/luafilesystem/archive/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://ghproxy.com/https://github.com/luaposix/luaposix/archive/refs/tags/v36.1.tar.gz"
    sha256 "e680ba9b9c7ae28c0598942cb00df7c7fbc70b82863bb55f028ea7dc101e39ac"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # We install `tcl-tk` headers in a subdirectory to avoid conflicts with other formulae.
    ENV.append_to_cflags "-I#{Formula["tcl-tk"].opt_include}/tcl-tk" if OS.linux?
    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To use Lmod, you should add the init script to the shell you are using.

      For example, the bash setup script is here: #{opt_prefix}/init/profile
      and you can source it in your bash setup or link to it.

      If you use fish, use #{opt_prefix}/init/fish, such as:
        ln -s #{opt_prefix}/init/fish ~/.config/fish/conf.d/00_lmod.fish
    EOS
  end

  test do
    sh_init = "#{prefix}/init/sh"

    (testpath/"lmodtest.sh").write <<~EOS
      #!/bin/sh
      . #{sh_init}
      module list
    EOS

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end