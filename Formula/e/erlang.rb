class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https:github.comerlangotpreleasesdownloadOTP-26.2otp_src_26.2.tar.gz"
  sha256 "a85fa668a292868a7dc8c8ac18615995051392acbfbfa9cef1e8d84cf417ca87"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^OTP[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2108348b686d2ab1c2bfcb0aed18f751eb1e74cef934bc15a33f1b3f165d7be2"
    sha256 cellar: :any,                 arm64_ventura:  "f00d501ac94934c355cec9fabb434c523eb7bfc97d5d6a51976edef572c88bd9"
    sha256 cellar: :any,                 arm64_monterey: "78ce005b908b5a37d70a5bda00bced2333c9ca8e0440a5bba176be32ce72398f"
    sha256 cellar: :any,                 sonoma:         "2edf621199fb1cf6d1ba83e025a1e32dcea44be2a3a4d33f521dbac5aacc8ffb"
    sha256 cellar: :any,                 ventura:        "d38e7872861d107c86ac21ad96ca20296a4cd7928e24b1cc9db43c9fc245acc5"
    sha256 cellar: :any,                 monterey:       "9cb8f240deba92b6904adba5579dedf5dc8f02e297d1bbe1731b360d9738b867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7b05d4c1d179fdfe06dcf39f16a164bec29615cae12e0608e2064bf37b2e774"
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
    url "https:github.comerlangotpreleasesdownloadOTP-26.2otp_doc_html_26.2.tar.gz"
    mirror "https:fossies.orglinuxmiscotp_doc_html_26.2.tar.gz"
    sha256 "ab8720886a79bb56c0d986b7554528fd3dbddbbd28f2736eeda82066ce8fce2f"
  end

  def install
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
    assert_equal version, resource("html").version, "`html` resource needs updating!"

    system "#{bin}erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
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