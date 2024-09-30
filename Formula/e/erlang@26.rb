class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.3otp_src_26.2.5.3.tar.gz"
  sha256 "c2707ce08e91235145cdfc487352f05570a2a0bddf1c478154549eb9e68805b0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(26(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7123397d6c2c3a04202c80670491ebafc0cdd5cfd33d8b86e5f63531d947fbf7"
    sha256 cellar: :any,                 arm64_sonoma:  "d5bfbcdb823475f03474483470759abf7cf1dd40792f5a22ce6cf8c568a98141"
    sha256 cellar: :any,                 arm64_ventura: "2d6a4736a0fdc17289c0bd7b031fe0ee3d9c119dc68f65c9c5ecc04eb52ef24f"
    sha256 cellar: :any,                 sonoma:        "15d58fb0cb6ca9b788e9d89ba7d6548d9b1f227cfc0c368b69f874db12d32d9d"
    sha256 cellar: :any,                 ventura:       "7f91a620be4c38ebf2cd9881c15972cb4f3f8c36dc83b207a437da0d4cf5a6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "879b4c3bacfe71a16a5211aa7bbf2fa50db866d5d2a40dee1cdd306496d016ea"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-26.2.5.3otp_doc_html_26.2.5.3.tar.gz"
    sha256 "466fc024ac6269312854f037ca5e937646ef43d709b11dde8c6893230f5aeade"
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