class ErlangAT22 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-22.3.4.26/otp_src_22.3.4.26.tar.gz"
  sha256 "ee281e4638c8d671dd99459a11381345ee9d70f1f8338f5db31fc082349a370e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d26db2560ad641c9aa425db4a43e2d7193cacd601b850c386df742c84b2baedb"
    sha256 cellar: :any,                 arm64_monterey: "2ba527cab790a8626160c04d7de0cf7278c2cf1e5aac1b21e50e174dc4a32e04"
    sha256 cellar: :any,                 arm64_big_sur:  "b28d77105c4f07dd1f56d186d5b0936b2285571d45ffdb996db374bc79b7d752"
    sha256 cellar: :any,                 ventura:        "3997639f66544cb71a4db00ed8ba0fb9be333923b90910b8e016a18049eaa33f"
    sha256 cellar: :any,                 monterey:       "e5ce1a93dca9e9d852c706668c195a47e563b24c463a4b0dc56d39e2190958f2"
    sha256 cellar: :any,                 big_sur:        "d57077a6791cdf18075a3754a6417e05f510f6ab2496ea08cbdb62a4fbdca093"
    sha256 cellar: :any,                 catalina:       "e78a4e2340c647879851eb98fd8dda806a4ccded8f1f4b1ec735e29f7c7ce6a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ecd6df4191c020f807aa9f8e928cf469ac20d94db8ee6b248c647a36a460f8d"
  end

  keg_only :versioned_formula

  # EOL with OTP-25 release
  deprecate! date: "2022-09-20", because: :unsupported

  depends_on "openssl@1.1"
  depends_on "wxwidgets" # for GUI apps like observer

  resource "man" do
    url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_man_22.3.4.25.tar.gz"
    sha256 "b715aada5a3abf0699d1c05ed55bd57f2110fb8fc58a9a67b6519d8ff8195fa8"
  end

  resource "html" do
    url "https://ghproxy.com/https://github.com/erlang/otp/releases/download/OTP-22.3.4.25/otp_doc_html_22.3.4.25.tar.gz"
    sha256 "90bfd716b2189b858a62cf09503ab02eba211753e44025d39e800490642e0fa7"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

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
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
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

    (lib/"erlang/man").install resource("man")
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