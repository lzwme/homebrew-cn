class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https:www.vim.org"
  # vim should only be updated every 50 releases on multiples of 50
  url "https:github.comvimvimarchiverefstagsv9.1.1450.tar.gz"
  sha256 "9d7da37891a07b089ecd0193883ca78898c41832036c10b83695071800e3a15f"
  license "Vim"
  head "https:github.comvimvim.git", branch: "master"

  # The Vim repository contains thousands of tags and the `Git` strategy isn't
  # ideal in this context. This is an exceptional situation, so this checks the
  # first 50 tags using the GitHub API (to minimize data transfer).
  livecheck do
    url "https:api.github.comreposvimvimtags?per_page=50"
    regex(^v?(\d+(?:\.\d+)+)$i)
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
    sha256 arm64_sequoia: "241ddc8d7c0d14b84c1bb827cc29e0beae7eb46e137ff58969b462b50d9520b3"
    sha256 arm64_sonoma:  "6b8fe0c9987735d587c13683b8cd6be97f731057e9ada6f463fa96c558a046a2"
    sha256 arm64_ventura: "fc88960059dba80d3de8a50b91a4343879e0911c3e59cc9258fee67a32341fdf"
    sha256 sonoma:        "9d6c243920557b4f04d253a2162e851637394f780803081d1e83c0302acedfab"
    sha256 ventura:       "06c145a4e8d6a37095e318a1b2130ca2c02361dd424ab1e06628d059444522af"
    sha256 arm64_linux:   "767c7138f237454c60012c57920746b624a1caf0cf10502df10dc42cd5e47ae0"
    sha256 x86_64_linux:  "66d26adb299c6516c21c526f7f719569c4f5edd28cd66e375ffa39534d70776b"
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
    because: "vim and ex-vi both install binex and binview"

  conflicts_with "macvim",
    because: "vim and macvim both install vi* binaries"

  def install
    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec"bin"

    # https:github.comHomebrewhomebrew-corepull1046
    ENV.delete("SDKROOT")

    # vim doesn't require any Python package, unset PYTHONPATH.
    ENV.delete("PYTHONPATH")

    ENV.append_to_cflags "-mllvm -enable-constraint-elimination=0" if DevelopmentTools.clang_build_version == 1600

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
    (testpath"commands.vim").write <<~VIM
      :python3 import vim; vim.current.buffer[0] = 'hello python3'
      :wq
    VIM
    system bin"vim", "-T", "dumb", "-s", "commands.vim", "test.txt"
    assert_equal "hello python3", File.read("test.txt").chomp
    assert_match "+gettext", shell_output("#{bin}vim --version")
    assert_match "+sodium", shell_output("#{bin}vim --version")
  end
end