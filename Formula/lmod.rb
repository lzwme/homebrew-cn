class Lmod < Formula
  desc "Lua-based environment modules system to modify PATH variable"
  homepage "https://lmod.readthedocs.io"
  url "https://ghproxy.com/https://github.com/TACC/Lmod/archive/8.7.30.tar.gz"
  sha256 "ab5bcebbc84aef816471f0e78b3cb9d471a2555a66209dc21462faf4aea15d6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e5806ee5a8bf807d3ff531e2caf1c0870ee75ce200d25d301dfe38cc6103469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3939bc30bdb067f397c42399d8816c749da169dceee15469ba18c502642d4cb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef983cdde473717f50258b307ece89d8b3acec0df2722a37839e33658b3a79e"
    sha256 cellar: :any_skip_relocation, ventura:        "1e297eebb277ae6043b82b3d3298b95e38fb622ca7e7fe537142f226d535d856"
    sha256 cellar: :any_skip_relocation, monterey:       "910bc653e8e81594e9fa9efc8f151139f3fbac781098e12e456f7fd785b97d38"
    sha256 cellar: :any_skip_relocation, big_sur:        "14dbd7c65ea81158322e02d71ed7804264f61f2c0621f48c6877eadafb922420"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6dd82640f77284f28e4a12e72b9854e8b86a624547b81e5d51e0d74954a671f"
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