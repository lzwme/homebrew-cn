class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https:www.vim.org"
  # vim should only be updated every 50 releases on multiples of 50
  url "https:github.comvimvimarchiverefstagsv9.1.0050.tar.gz"
  sha256 "a520a9858eb802dca493d98448a4c53140c46e8eebb6d0655f9c20cdcec6b227"
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
    sha256 arm64_sonoma:   "d9d8d9eebfa5957dfa2bbacba6bf82709b3f467df107d5a26fac67272cb451f1"
    sha256 arm64_ventura:  "64020ba3e2f2f6757853dea01b780f84264f5ce834190219e83e314ec02b765b"
    sha256 arm64_monterey: "5a3b25197a088aee209cdfa49cdd0559dd011e788f4956e551002a634f5b539b"
    sha256 sonoma:         "4638f17407b666d9a0245b3342de020577f9febbcb3f9f66b1e73c8bac9a482c"
    sha256 ventura:        "a35800616c5c02c8c5076dd10e451bf276edb158fa320a217c45288fbf3f4e66"
    sha256 monterey:       "f0f4e8bed7e9cc2dded45cb64ca40d2889f5e2f626a87585e72a57c774f7fe6b"
    sha256 x86_64_linux:   "7757648845228e5b10b7da5aee8dde58d321d61dda216779603720f742881931"
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