class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.28.tar.gz"
  sha256 "e489b71990010ee072ccbace610a899033412f6e11e261440240ff9732f478f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b87a28c3f0e81d902df0e6ede5535246d201a7eb4fe2ee20f66d856bfbd1b57e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f06e0136157487be0c818918f93d322889f34420e0834c78a2cc8d390ba1d5b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d417ec683c921a9f252d416b96d36457dbb961f12f4d043d53aca4c887f767"
    sha256 cellar: :any_skip_relocation, ventura:        "c86e61fef6606219c8338343ccab8cc1bb5fff4b25a0dbe4cb972ee49076c5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "1b16cf4f4bb4b84556734057b1f693b09db9bb25754790b5a0369e68b2b963d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfb9183e3206b69dcaf5d0d1375d6475156cd370933ac5c65fe3c42040643faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4319ace226838e6dc471af2d2766c6971e3358a2671c2a45b406e3e1bca2e12"
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