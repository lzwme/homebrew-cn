class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.18otp_src_25.3.2.18.tar.gz"
  sha256 "6ea82a2d3907d94c7d044795708fecf0af580ec6488a0673d2085dd1ea40b499"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(25(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a5b944939c529b417ee1bd201b3b23d42b208b5216d64fbfad8a7cbc57b28c1"
    sha256 cellar: :any,                 arm64_sonoma:  "e6471ab130d0874088db92cc1e5fdd4c8cdc473a5fe8b601831a37f48c42d2df"
    sha256 cellar: :any,                 arm64_ventura: "9c57ffd89cbfde7572da8bfca5e830133bf59ae87b7a45d4563f28befe720904"
    sha256 cellar: :any,                 sonoma:        "337ad4f832fe39575fd3a5c5e6462639d1eac16c97359db11433bc2943827b5d"
    sha256 cellar: :any,                 ventura:       "8a60314e2310adb5f44da413750a06c3b4695c2ddffbe971faaca20e6a5f3eb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfdf3877a5d4d8d7b90238d269778096758dbda800ef7e4a28d76f22c6137feb"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.18otp_doc_html_25.3.2.18.tar.gz"
    sha256 "17a11a116c04922905d6d8f56da30fca8a1dc5516b82b227595557d5676fefb5"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system ".otp_build", "autoconf" unless File.exist? "configure"

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

    system ".configure", *args
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