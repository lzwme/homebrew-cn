class Erlang < Formula
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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "bac376cf4cabd3e324aab400dfdd03c8b1c99a9f14785f73b7cb56059c5dea69"
    sha256 cellar: :any,                 arm64_sonoma:  "076a5512381aa576496bc0e3e1ebc4c937ede8eab2ed47673cecae482baa3d4c"
    sha256 cellar: :any,                 arm64_ventura: "0cb58c48c04146ced67ee1d9f457674f34b082467d4c516fcf921647f83bda55"
    sha256 cellar: :any,                 sonoma:        "229ad05835575a4f72e618ce552a63e23dcf0d9b50052fa1dea8028fc8106f6b"
    sha256 cellar: :any,                 ventura:       "e4518dd0a3e65dce26d3b139c81365dfb1039a9856081f6283a537d3167e66fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "493b0af312f3e8fa6e1c06c06b6bf639ce1157d0798221fd5a982ed318ce34c6"
  end

  head do
    url "https:github.comerlangotp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5otp_doc_html_26.2.5.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_26.2.5.tar.gz"
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