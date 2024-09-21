class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2.5otp_src_26.2.5.tar.gz"
  sha256 "de155c4ad9baab2b9e6c96dbd03bf955575a04dd6feee9c08758beb28484c9f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9194410784163b15850db2ded3c18e57ae04251fb8412afb01f40a47a9630e2f"
    sha256 cellar: :any,                 arm64_sonoma:  "6f17b1b3f5969ba5cc962181c2e21194f3d81fc92b33f97bce8fe5c7d9d6362f"
    sha256 cellar: :any,                 arm64_ventura: "482c27d1ab22a3ecdf9bb99aed1617c5ecc27400a8b1da19af03fa9d11d455d8"
    sha256 cellar: :any,                 sonoma:        "29210a65d0354019005bf2bdc8771ad438a31e2a38af16ab18e8b642581a7164"
    sha256 cellar: :any,                 ventura:       "cfaac2e6c5e5c22785670fef85862a01b5bf7f55d81115ac38b5871c26875583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3760323bf424e95774f7a47d5eeee495675cd0b861c3aba12484416343d4aec0"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5otp_doc_html_26.2.5.tar.gz"
    sha256 "7c9c99695f8b0218f655ec154954bac1d70e25fe3d54810cf81590e1eb711e47"
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