class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https:www.vim.org"
  # vim should only be updated every 50 releases on multiples of 50
  url "https:github.comvimvimarchiverefstagsv9.1.0.tar.gz"
  sha256 "ddb435f6e386c53799a3025bdc5a3533beac735a0ee596cb27ada97366a1c725"
  license "Vim"
  head "https:github.comvimvim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first page of tags on GitHub (to minimize data transfer).
  livecheck do
    url "https:github.comvimvimtags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "ab0dd65931cc8626a5ed089fe601de83180579c087b294cb47f162c66ed85d57"
    sha256 arm64_ventura:  "ca4a9eefa8c3701595f9d154fad524466f83ad10a5dde76fc2bf50113c9fa400"
    sha256 arm64_monterey: "69f1acd3bfd08464676fc2bad9db81097922c5856f6ffc06117b3a01dfcfabe2"
    sha256 sonoma:         "ee91ce7b7107e3ed62dc487157ed2ddde0388603fe85f42f4481521526cec7f7"
    sha256 ventura:        "46247d11f59d8aed92118bbb94204f060ac9a5e27e1fd99728ada802e04b9bcb"
    sha256 monterey:       "d3d0a8c8c3757e25e74918c753f75480094f99ff630851a98b83c6e093c45ba2"
    sha256 x86_64_linux:   "6958e315386faad0cfa5d65c2d4b2912ed987c9601685c43a1f32b4a27967af2"
  end

  depends_on "gettext"
  depends_on "libsodium"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.12"
  depends_on "ruby"

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install binex and binview"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.12"].opt_libexec"bin"

    # https:github.comHomebrewhomebrew-corepull1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIXsharevim{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system ".configure", "--prefix=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          "--with-compiledby=Homebrew",
                          "--enable-cscope",
                          "--enable-terminal",
                          "--enable-perlinterp",
                          "--enable-rubyinterp",
                          "--enable-python3interp",
                          "--disable-gui",
                          "--without-x",
                          "--enable-luainterp",
                          "--with-lua-prefix=#{Formula["lua"].opt_prefix}"
    system "make"
    # Parallel install could miss some symlinks
    # https:github.comvimvimissues1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https:github.comvimvimissues114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}vim --version")
    assert_match "+sodium", shell_output("#{bin}vim --version")
  end
end