class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.19.tar.gz"
  sha256 "1d706ef7f50378dd869ece2081a6b116ae59ede82f6cd7ca2771c6a33e3ddcf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83f10926dfd4462068ed15aa0ac8e2dd7177df2ba8e61ac2cdcb51fba207dd59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feb221e05f092f479a7a52405d9dd7885290e6b2959f0b96b48add94e6787583"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e3ffcb3b8ef175e8a57cc09dcea09b0f70f1504f5be78a6b8d01fdd7b9bf24"
    sha256 cellar: :any_skip_relocation, ventura:        "6043d0a5eefa97d164f2e0ee9fd11efc03b91fea193be2fbda8d662927fa13bf"
    sha256 cellar: :any_skip_relocation, monterey:       "213c4443af4f69829e5b0e0a24d1f7eb8faadae527f64ed9a13ca591aaf0a82d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6d625e6f7f219b43740cc1b37a2bfda56ac15a0931c2b7a364cf0e2a9fb7111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b338a6421b0b63ded903f8617fba26587a46aa07c1d8568450d33228bf2ce8"
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
    url "https://ghproxy.com/https://github.com/luaposix/luaposix/archive/refs/tags/v35.1.tar.gz"
    sha256 "1b5c48d2abd59de0738d1fc1e6204e44979ad2a1a26e8e22a2d6215dd502c797"
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