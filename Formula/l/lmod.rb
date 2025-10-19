class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.0.1.tar.gz"
  sha256 "c4ec22edbedc66f879f153d8332edeeba270668e0864f11941071de21fa39258"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47bbb91e4c1f295ed19df0476cb839326175f207f9f3d67268280d5a6fefffb7"
    sha256 cellar: :any,                 arm64_sequoia: "df152d7df71cdf65e28bc3f79e6679d89c045721bcd8462ebdae66a532a31d19"
    sha256 cellar: :any,                 arm64_sonoma:  "03f92c10bfd34886e7cbee44da9c6a71f55f10623754d3055f3dd7ecf0236a17"
    sha256 cellar: :any,                 sonoma:        "b340750f3850449331a2cd5a2b2238d096580755579b010c7e92da0f73b10c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef19c1a2bb046d964b34eacdbd67355e47e5fe5b262ea03a0ad060529bfa034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45ea01c861f7ddba634f186f791eca86949a7fe8fe3869966670304c23899dcc"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua"
  depends_on "tcl-tk"

  uses_from_macos "bc" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://ghfast.top/https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://ghfast.top/https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_8_0.tar.gz"
    sha256 "16d17c788b8093f2047325343f5e9b74cccb1ea96001e45914a58bbae8932495"
  end

  resource "luaposix" do
    url "https://ghfast.top/https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    luaversion = Formula["lua"].version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}"
      end
    end

    # configure overrides PKG_CONFIG_PATH with TCL_PKG_CONFIG_DIR value
    ENV["TCL_PKG_CONFIG_DIR"] = ENV["PKG_CONFIG_PATH"]

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    system "make", "install"

    # Remove man page which conflicts with `modules` formula
    rm man1/"module.1"
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

    (testpath/"lmodtest.sh").write <<~SHELL
      #!/bin/sh
      . #{sh_init}
      module list
    SHELL

    assert_match "No modules loaded", shell_output("sh #{testpath}/lmodtest.sh 2>&1")

    system sh_init
    output = shell_output("#{prefix}/libexec/spider #{prefix}/modulefiles/Core/")
    assert_match "lmod", output
    assert_match "settarg", output
  end
end