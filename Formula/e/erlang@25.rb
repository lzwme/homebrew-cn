class ErlangAT25 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https:www.erlang.org"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.13otp_src_25.3.2.13.tar.gz"
  sha256 "00c2619648e05a25b39035ea51b65fc79c998e55f178cccc6c1b920f3f10dfba"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(^OTP[._-]v?(25(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "26b32ad1bcb678e1fe8127f590b6d483add5c7eb03c4badc92311dc9ff3d7c43"
    sha256 cellar: :any,                 arm64_sonoma:   "a395dfc71491c4b95aea25b495a766f27adf4589057ca6dd4091ee2c21ac4c34"
    sha256 cellar: :any,                 arm64_ventura:  "a946e8e54089ea35dacb98012b66dab4cbd9d6ecee7a61ffa4d69a34d18a7693"
    sha256 cellar: :any,                 arm64_monterey: "dab735ca2c1603594f1d66545c91787712e5b00c25f5f541cbfe9ceebfe671c1"
    sha256 cellar: :any,                 sonoma:         "31384b14d4c671b2ff630931f79425d250faef4cb1530ccde6b071433eeb10e2"
    sha256 cellar: :any,                 ventura:        "afcadfb0973e83f1cc58debc3c54bdbc27e0ed64e0f58ed45a5dfe3f683435d9"
    sha256 cellar: :any,                 monterey:       "558edcf14a877c8ccc23a030fa156b559157076d4b74d633c0d645a8de8611ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a9150e723c42878d15665bd769412e42b6199a94295babb9af219b344901933"
  end

  keg_only :versioned_formula

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets" # for GUI apps like observer

  uses_from_macos "libxslt" => :build # for xsltproc

  resource "html" do
    url "https:github.comerlangotpreleasesdownloadOTP-25.3.2.13otp_doc_html_25.3.2.13.tar.gz"
    sha256 "d57d0b5426a120531b3109c91d604765f386fc5c4420c861fcf259430cfb3671"
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