class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.22.tar.gz"
  sha256 "6452cdff871c7f8dd5dc3c447e7db53603af3d2d970f17ffa3f6046fbc1ab95e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6be9263357e6cb224ca9203183baba4b39a064b94e1e850863ffbc532aa71974"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7aaaa64df2ebe190e6d1c3a1d11e9c9e91b4763d4d8dfe8572553e11ca43fe6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82f595cfff83134c5dd45d9e23f1aff4975aeea1ca9abb61b92b79295f1be803"
    sha256 cellar: :any_skip_relocation, ventura:        "90f732a9a0a8e50b5f74971c78e56ae9d6caabce1845528325846bd5f4db2b32"
    sha256 cellar: :any_skip_relocation, monterey:       "c8643605c95302995e4a1ea4701870e0975b7ba7aa215f108e60985f1636c8f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "d74283dc3c585a4f69db3a01aa49333300f0654b9dbfa802dc6bcfd73d9b89be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ac021685ecab7ba5905a01bd124d9c6b96da617fd39d84fa2d468f12ac6195f"
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