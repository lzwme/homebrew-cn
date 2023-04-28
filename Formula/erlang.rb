class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.1/otp_src_25.3.1.tar.gz"
  sha256 "1d5e4b97a7cfa0afa8787ae60a66426806f55897085dde1fd553ac2db39a6082"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b15ee12be4bf6cc045cecc2f880589165a1ce32196cf5716abfa6ce3765a02a5"
    sha256 cellar: :any,                 arm64_monterey: "28683ee87242548e508587c8e207ec50857dba62e01dc2e956e56230624fa7f2"
    sha256 cellar: :any,                 arm64_big_sur:  "59a2b019a811250118ccd7439c231639d113fbc7db0790445520942bb2b56a9e"
    sha256 cellar: :any,                 ventura:        "5ec22277c664b20201b9cac1242cacdedbb2dcdebe04b608f6f183dfdbb12d3a"
    sha256 cellar: :any,                 monterey:       "6db001c1872213c9ebced7a9d7abf029f7eea58d1a8821ed113dc15d533e7786"
    sha256 cellar: :any,                 big_sur:        "d245e6c61f8fb1ee409f793749f7a3af69a8b82747452ff09ae779194e63389c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20aa43d8e64754a6a5a2b484e977caba3941dc7de2f85587876b532a63d0ca6e"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-25.3.1/otp_doc_html_25.3.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_25.3.1.tar.gz"
    sha256 "006e6ea150e012b4b054325ac94bf55c75b7301aa606c8c923b82ea5c6fd0020"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *std_configure_args, *args
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