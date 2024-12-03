class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https:www.vim.org"
  # vim should only be updated every 50 releases on multiples of 50
  url "https:github.comvimvimarchiverefstagsv9.1.0900.tar.gz"
  sha256 "30efb714ed82c5d7a1491f3e4aac6487d2c493d33c834d7ef043e6f45176772e"
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
    sha256 arm64_sequoia: "355ad66fb8f3eb9b5fc94631a9e7cf17014039616bdf864ac49d19de93eb00bc"
    sha256 arm64_sonoma:  "5e632b371b29ba16c8b12ee2487eba3d08fcdda4c60fba52eaedee8c0040b3f6"
    sha256 arm64_ventura: "047b6cca6703e235911d4399f46d2f40bb2cca1b67615d7cb4a6d7a3794fc1ac"
    sha256 sonoma:        "31f5167572cc81d6ed571401564d88b81513810ab7eb13c06efb2f220d4d2af7"
    sha256 ventura:       "afc8d120cac9a44a8e9c0119be9aacaeb4d0017593084c61aaadc99e96bdef73"
    sha256 x86_64_linux:  "a76dc7b7d574f8fc437181a12b04f45b49f1c0b1aaf36c01f28a9c6e1b0739b0"
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