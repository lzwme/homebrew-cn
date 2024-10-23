class Vim < Formula
  desc "Vi 'workalike' with many additional features"
  homepage "https:www.vim.org"
  # vim should only be updated every 50 releases on multiples of 50
  url "https:github.comvimvimarchiverefstagsv9.1.0800.tar.gz"
  sha256 "3bc15301f35addac9acde1da64da0976dbeafe1264e904c25a3cdc831e347303"
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
    sha256 arm64_sequoia: "9ab4bf1ee348fe082f4bd55418b0004e37e2c4e02b145e1547dd3ec30551fba0"
    sha256 arm64_sonoma:  "9c3a9718fa9690a749d26b2a5c74362520b26617827d49bec8237b68e55384a2"
    sha256 arm64_ventura: "ef07a3be799515df373da0d5bde74298cea4c6cdfde77f7f3eda491ec9bcd8bc"
    sha256 sonoma:        "899adf0532102067c8f50f13a21ee1caf5e137f4cade37579269573f41367fad"
    sha256 ventura:       "69ae385f5629fb4859d9d99c64f138beca36dba670aabbaf7647a7f89fb49296"
    sha256 x86_64_linux:  "774c736c4924d8c5c2a5e202518da2120c1368d04c2bb544fb6dabafc521fc73"
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