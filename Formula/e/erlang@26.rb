class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.5otp_src_26.2.5.5.tar.gz"
  sha256 "d6e92683cc7505faf124252d390ba14d0c335d15a138c6b770d3b80b33db8f48"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(26(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f6c3af0b817c0e3bb9cccde6ddb4f0d97b7a595a2f706df1afaa9d975879a21"
    sha256 cellar: :any,                 arm64_sonoma:  "4c1007a0253e337e891fb06e7bc6e775fa2b95a4f3aed78ff069428f4ba4bddb"
    sha256 cellar: :any,                 arm64_ventura: "90edcbd0cee38fef55beb63db325ca895813df0816f4c098e7f00947a12223b5"
    sha256 cellar: :any,                 sonoma:        "37bfdc02d6e3a9b85bc9b2ce7cf28592f259f9acaa0e134daa7d4a449d8480e6"
    sha256 cellar: :any,                 ventura:       "6e0b4288d2252ac61a5d00549002b92e0e04d55b3b0dfda7fcaf4ce5444eb09a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ea61e35544638d30ed17752c2841ad2364c9537ecc4a793c3aeab515bedfda2"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.5otp_doc_html_26.2.5.5.tar.gz"
    sha256 "07a1320917e7f6c21d2d3d1cf27e77123f2216a6e5f10b95e75756259479c9cc"
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system ".otp_build", "autoconf" unless File.exist? "configure"

    args = %W[
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

    system ".configure", *std_configure_args, *args
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
        #{opt_lib}erlangman

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system bin"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

    (testpath"factorial").write <<~EOS
      #!#{bin}escript
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
    assert_match "usage: factorial integer", shell_output(".factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output(".factorial 42")
  end
end