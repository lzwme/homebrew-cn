class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.2.2/otp_src_25.3.2.2.tar.gz"
  sha256 "83a36f3d90deef36adb615bbfb46cd327f0b76b7668e1f7f253fd66b4ae24518"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(25(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73ed0663012d8f60f290e24b57217aca3f69494f1748f51b9b1408cd4b1533ff"
    sha256 cellar: :any,                 arm64_monterey: "85a1bb4d254e383cba643c383120e7b4b323e10df3c6491424190517da40fef8"
    sha256 cellar: :any,                 arm64_big_sur:  "b1ba80c82f2502245a485a1ade0b337a54be726ab9233ab99cf55c6d0a0eb32a"
    sha256 cellar: :any,                 ventura:        "a4ac143b8f6f8033fda5a41a94fa793caee7ac5e53ebad2a09cfa20e7b0318d3"
    sha256 cellar: :any,                 monterey:       "68e409b7f8b9337cee6fb993f53e30d6dc6f58766ac431ef2c9c50c021d4e9d7"
    sha256 cellar: :any,                 big_sur:        "1221902d898182748e3d15383f0d3510a6af6a69b1f51f570d353e27afdbd587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0ce5150277e375d501c9bf2af1c28006f990bd803beb1a64593788c0f8f2ffb"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.2.2/otp_doc_html_25.3.2.2.tar.gz"
    sha256 "29412cd7d490aeee51a5386faceee357fe134ba10fdeed44c224242a2e0a66d4"
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