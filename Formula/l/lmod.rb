class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghfast.top/https://github.com/TACC/Lmod/archive/refs/tags/9.2.3.tar.gz"
  sha256 "337cb0bdd6defbb53c020d00f5c776eb6ad4535386df11738fd260cf351dc13f"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dceeea792a316f2082883345afeb5bda0e4c820ee89d1edafc3d3a7504005c96"
    sha256 cellar: :any, arm64_sequoia: "defd24980d6fb214036b4a9508d9fc579b4688e6d2ce7379975fbf9422cebb84"
    sha256 cellar: :any, arm64_sonoma:  "abc725707912cccef66b81a467c1efef3ec7d5d1ccaa9d98cd7e8b20b7c50c5a"
    sha256 cellar: :any, sonoma:        "dab5d94c11b40f3fcb47446b7d1e15798a0c0667accf812b2d06a8a166ac7635"
    sha256 cellar: :any, arm64_linux:   "f51667f9a0887692812799b5ef06792cc42bbfc4ebbabda2bb3d065ce2aeefec"
    sha256 cellar: :any, x86_64_linux:  "e4c1a88f28a5f154bbd802d5d7d928a4b156287753169bff4a7cbc63c8df4ff3"
  end

  depends_on "luarocks" => :build
  depends_on "pkgconf" => :build
  depends_on "lua@5.4" # due to luaposix
  depends_on "tcl-tk"

  uses_from_macos "bc-gh" => :build
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  resource "lua-term" do
    url "https://ghfast.top/https://github.com/hoelzro/lua-term/archive/refs/tags/0.8.tar.gz"
    sha256 "0cb270be22dfc262beec2f4ffc66b878ccaf236f537d693fa36c8f578fc51aa6"
  end

  resource "luafilesystem" do
    url "https://ghfast.top/https://github.com/lunarmodules/luafilesystem/archive/refs/tags/v1_9_0.tar.gz"
    sha256 "1142c1876e999b3e28d1c236bf21ffd9b023018e336ac25120fb5373aade1450"
  end

  resource "luaposix" do
    url "https://ghfast.top/https://github.com/luaposix/luaposix/archive/refs/tags/v36.3.tar.gz"
    sha256 "82cd9a96c41a4a3205c050206f0564ff4456f773a8f9ffc9235ff8f1907ca5e6"
  end

  def install
    lua = Formula["lua@5.4"]
    luaversion = lua.version.major_minor
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?.lua;" \
                      "#{luapath}/share/lua/#{luaversion}/?/init.lua;;"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/#{luaversion}/?.so;;"

    resources.each do |r|
      r.stage do
        system "luarocks", "make", "--tree=#{luapath}", "--lua-dir=#{lua.opt_prefix}"
      end
    end

    # configure overrides PKG_CONFIG_PATH with TCL_PKG_CONFIG_DIR value
    ENV["TCL_PKG_CONFIG_DIR"] = ENV["PKG_CONFIG_PATH"]

    system "./configure", "--with-siteControlPrefix=yes", "--prefix=#{prefix}"
    ENV.deparallelize # Work around "install: mkdir .../share/man: File exists"
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