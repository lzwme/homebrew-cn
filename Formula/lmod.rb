class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.29.tar.gz"
  sha256 "daf6e6224e2cfa918b324ffa10028ca8d3162fe93a3a022d9ab23a6a55356c49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "506fce21e90803030f6ecb7083d4f0eaa92a184afe4f38f80e8fc150e7ecc3eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d424c66c2b9a0ef7f88f5c8160dbd8f622215232bba8e2c0c72be03e6f6962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02123ada51c6c0ac39f1240a4694c141fc9b89a5d50a37c6cf2d854c70aa4ebf"
    sha256 cellar: :any_skip_relocation, ventura:        "2542af29c2805f0955c62f418aaab875bee328ca2689fd0cc4e835f82125853a"
    sha256 cellar: :any_skip_relocation, monterey:       "a0a930a854175dbdd294d484d2a3207255dd0f0baa32a4de2dc3b5ae8e387fe4"
    sha256 cellar: :any_skip_relocation, big_sur:        "39c4dec873d68b9412871ef967abdb5737fb1f9c4185b90dc50ceadeab5fb6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce39695b813c65c1b04e2975a0d6ef4220adea89e0c79a8b98288c6a330372d1"
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
    url "https://ghproxy.com/https://github.com/luaposix/luaposix/archive/refs/tags/v36.2.1.tar.gz"
    sha256 "44e5087cd3c47058f9934b90c0017e4cf870b71619f99707dd433074622debb1"
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