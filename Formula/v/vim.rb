class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://ghfast.top/https://github.com/vim/vim/archive/refs/tags/v9.2.0150.tar.gz"
  sha256 "bd56f5981eb4cb971eaf58725bf590f4b4c067b911b8e70dcd813b7de2392197"
  license "Vim"
  head "https://github.com/vim/vim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first 50 tags using the GitHub API (to minimize data transfer).
  livecheck do
    url "https://api.github.com/repos/vim/vim/tags?per_page=50"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :json do |json, regex|
      json.map do |tag|
        match = tag["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
    throttle 50
  end

  bottle do
    sha256 arm64_tahoe:   "0d27f1d93093b1a44a7a56c40765aca1bfde3a986ae063e52edadc4abd6c4a27"
    sha256 arm64_sequoia: "a5dae39c776c23c8c07860be8ff4c0fee887c6f9435fc1d43d136698259f3278"
    sha256 arm64_sonoma:  "393c7600207f67b18ec30225c21fe40579874fb979adcb272b4c64d99c135663"
    sha256 sonoma:        "8137023ede6342a84b937f2535b68bfc7f791cd34a81485c4935fd588f868c89"
    sha256 arm64_linux:   "ef3864e6287227d253f8aefc86dea92953beab3bfd03abc74222f4cf20f1cf58"
    sha256 x86_64_linux:  "b85a79769d8a2fb137e322e1113a7fa1f6fd51aee46daab802fae1569d23b490"
  end

  depends_on "gettext" => :build
  depends_on "libsodium"
  depends_on "lua@5.4" # Lua 5.5 doesn't work for now, see https://github.com/vim/vim/issues/19639
  depends_on "ncurses"
  depends_on "python@3.14"
  depends_on "ruby"

  uses_from_macos "perl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi", because: "vim and ex-vi both install bin/ex and bin/view"
  conflicts_with "macvim", because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.14"].opt_libexec/"bin"

    # https://github.com/Homebrew/homebrew-core/pull/1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    ENV.append_to_cflags "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

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
                          "--with-lua-prefix=#{Formula["lua@5.4"].opt_prefix}"
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
    (testpath/"commands.vim").write <<~VIM
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    VIM
    system bin/"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}/vim --version")
    assert_match "+sodium", shell_output("#{bin}/vim --version")
  end
end