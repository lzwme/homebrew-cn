class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://ghproxy.com/https://github.com/vim/vim/archive/v9.0.1900.tar.gz"
  sha256 "c631c375565fb35c2e37bd0aea6aa79c0b25391ce3e9b093321876fa5dd47f66"
  license "Vim"
  revision 1
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first page of tags on GitHub (to minimize data transfer).
  livecheck do
    url "https://github.com/vim/vim/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_sonoma:   "d842cbaf82ca3bc891996c5cdb73552cdbdb15b713aee7d6fbd6e9d35422ce40"
    sha256 arm64_ventura:  "a99e0a4d26e506383b22ceadd358317d541cbebcc405c052dd5f52e1fbf09861"
    sha256 arm64_monterey: "4932285cbd3df5bba17df80c8557ce169f81e3d61a91d05ebc8c136a9c748e58"
    sha256 sonoma:         "ad1ddaca4fc5fc1be4950fbe0361e11ccabd7d1e626d78ba25cb3eaaa3e17f96"
    sha256 ventura:        "5115100eb905f75eac13ef12804fa43f9b7e33993abf9309ef85ecd421d3b32d"
    sha256 monterey:       "3e60a79644f38637753c88cd519e557a929dda0db8ef0bd281a6304c8844aa3c"
    sha256 x86_64_linux:   "059d6631d94874411cb00d9028eebfd3a20027ea0f57e8e7214e8b0cceeb3a55"
  end

  depends_on "gettext"
  depends_on "libsodium"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python@3.11"
  depends_on "ruby"

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    # We specify HOMEBREW_PREFIX as the prefix to make vim look in the
    # the right place (HOMEBREW_PREFIX/share/vim/{vimrc,vimfiles}) for
    # system vimscript files. We specify the normal installation prefix
    # when calling "make install".
    # Homebrew will use the first suitable Perl & Ruby in your PATH if you
    # build from source. Please don't attempt to hardcode either.
    system "./configure", "--prefix=#{HOMEBREW_PREFIX}",
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
    # https://github.com/vim/vim/issues/1031
    ENV.deparallelize
    # If stripping the binaries is enabled, vim will segfault with
    # statically-linked interpreters like ruby
    # https://github.com/vim/vim/issues/114
    system "make", "install", "prefix=#{prefix}", "STRIP=#{which "true"}"
    bin.install_symlink "vim" => "vi"
  end

  test do
    (testpath/"commands.vim").write <<~EOS
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    EOS
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end