class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https://www.vim.org/"
  # vim should only be updated every 50 releases on multiples of 50
  url "https://ghfast.top/https://github.com/vim/vim/archive/refs/tags/v9.1.1700.tar.gz"
  sha256 "7870ae57a21720a88f5171c2d4dbef09db42423ce2d5b45548800c190c5bf01f"
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
    sha256               arm64_sequoia: "361ff8d971bfd741f792c3494e34fb7baade98ccb46710a829202cbe683c7771"
    sha256               arm64_sonoma:  "f9e71df6bde31e6fb44dd891e1e68a609595c5cd0d8a515634ae4cf361d6e2c0"
    sha256               arm64_ventura: "f89d9568babf088f07fb3243aca9394a7c8034d9fcaad7cc15dd30e2b655a673"
    sha256 cellar: :any, sonoma:        "e1593b2f3550769086fb8df89ff6f188d80b47c2559aeed0b01aad94e71e0d57"
    sha256 cellar: :any, ventura:       "cde3c2e090d7ae3ab9cbd109879cbd5c6800334b829dda90a8ccda50a2f02648"
    sha256               arm64_linux:   "b299a4571c7a041b279a4f1d133e52a8ffe818b5bf9b9d56319f3a8cf9c26bcc"
    sha256               x86_64_linux:  "e41e1958db85869a0ac3a5e6fefa63b8d72b3e441e2400c44278305fba3e27b7"
  end

  depends_on "gettext"
  depends_on "libsodium"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "python@3.13"
  depends_on "ruby"

  uses_from_macos "perl"

  on_linux do
    depends_on "acl"
  end

  conflicts_with "ex-vi",
    because: "vim and ex-vi both install bin/ex and bin/view"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

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