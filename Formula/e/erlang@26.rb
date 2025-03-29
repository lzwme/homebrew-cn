class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.10otp_src_26.2.5.10.tar.gz"
  sha256 "e70265e3df9a5df831d6246bd379ead54ab8430d00cb4a9ba396a7dfcbb33a9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(26(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0f64e39964445a807066d25e25f13e290bd856ae056ae53d88b8f777eab46270"
    sha256 cellar: :any,                 arm64_sonoma:  "bfc9b1f42746feb41624706b928029444fdea6252014b82c8f6d0b7a51338c2e"
    sha256 cellar: :any,                 arm64_ventura: "209f2444d29fe182306695a0138d9835bbfa74dcb2547a7a1138406ad885b655"
    sha256 cellar: :any,                 sonoma:        "a148579a37f40e5311c7fb284cb96ab5420b36ef6b8eeeab2c238f4ec84e3445"
    sha256 cellar: :any,                 ventura:       "0db518f5857cd835a2bf0190e34b36830d209eb161446834dd26db83a86d726b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4996c990ee8a4dc2f652625efbadeb9878d0f1e7181656eb9fad40c10c8727d8"
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
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.10otp_doc_html_26.2.5.10.tar.gz"
    sha256 "7360cb611dda89f4f60bdf40613235be29d1d61ee793c07d1d6235fee73eebf9"

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