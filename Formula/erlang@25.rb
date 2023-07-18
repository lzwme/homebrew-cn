class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.2.4/otp_src_25.3.2.4.tar.gz"
  sha256 "9d224c098abbb48fbe42abb81bd04765efa2190d9eae4898f78183d9725a676b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35b966eee14a03693484490d08930e1efcd400c35cb4c8fe1b4f0642f0d00214"
    sha256 cellar: :any,                 arm64_monterey: "7f557a7f5197c5aab9cb5db4e15ac230a201dd6f95d146e40d5bb3d7561a6064"
    sha256 cellar: :any,                 arm64_big_sur:  "d4170f4c8caac5e651db3c732c2ef03c5c43dbb1272cb878e9f62a39fc108444"
    sha256 cellar: :any,                 ventura:        "b2b9eae4da6615757f0b8fe7a46b53bebb5792e0ca22e3a216e5ef327d1297fc"
    sha256 cellar: :any,                 monterey:       "4512c373d527dae4cc9cad4d45435b37d97e84cc466ca124b03eb94ba79d219a"
    sha256 cellar: :any,                 big_sur:        "538731778577d292815c8fa12bee6aa1a6a68b8c5953634b1c17512f6b1ea4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0c3e903e5d2e9033fd547dbe738cdc1262d49c26b1b3ee8e55706da7dded829"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.2.4/otp_doc_html_25.3.2.4.tar.gz"
    sha256 "6b8079f3a2cc1ffec648526ce24e9e38cb163f0edf8121244ebbf4595f07a168"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    assert_equal version, resource("html").version, "`html` resource needs updating!"

    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end