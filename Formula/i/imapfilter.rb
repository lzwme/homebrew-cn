class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://ghfast.top/https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.4.tar.gz"
  sha256 "836cf14a9736d15b251952a84e01d641d7dce78a7be6be94220beee81414dbfb"
  license "MIT"

  bottle do
    sha256 arm64_tahoe:   "82479e8d3d6b75a781a143bed81ce4224ebc2544ddfce6ba42854e10ae8fd89c"
    sha256 arm64_sequoia: "1c59e8d57e77dd4f7f4b1a45717edde8aa2a6e6cc11c271a6de82e314c3ccb65"
    sha256 arm64_sonoma:  "f12cfeb9981e4d73fe020e402ede9bf794ccbfe3b6565ec04738231a4c19a302"
    sha256 sonoma:        "ec7a4b41dc787446dbceb15e01b3eabc6f4da83331e61f0f2de8918702cb34f6"
    sha256 arm64_linux:   "3bbfe4804da1a89a4b673916837133704be0be74565391b93a7cdc927cdc0414"
    sha256 x86_64_linux:  "7ccd21bd7eefcdfc487ecb02ebf0ac53d6de9d4131de4b199c6d337623f02b32"
  end

  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-L#{Formula["pcre2"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["lua"].opt_lib}"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats
    <<~EOS
      You will need to create a ~/.imapfilter/config.lua file.
      Samples can be found in:
        #{prefix}/samples
    EOS
  end

  test do
    system bin/"imapfilter", "-V"
  end
end