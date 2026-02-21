class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-28.3.2/otp_src_28.3.2.tar.gz"
  sha256 "36380480aed888281b8202e75449cca307102e43c4e04696cc83bd3b162991cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a1f294aed35a097f22df68ae65ad172e61eb24b437a5be791a8a1862a00ac69"
    sha256 cellar: :any,                 arm64_sequoia: "72b9fcb39437fe6eb8aa4cc9e547ce2a55a4ce9da6a09c6482c2f2b033bceefd"
    sha256 cellar: :any,                 arm64_sonoma:  "10dd0c14cc8f6dd5e79aefee6fa9cd8f1964707dea55e2090e5ab05a6d2a5901"
    sha256 cellar: :any,                 sonoma:        "882dd04ed7d20d5fe94ef23a337ba79a7298dc09f829995f282c09b1348a92a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "554be98e73d60a8d86edadbe9cd9c659611c8bb3eb217be0cb47e0a7ce5540a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a30ccd610393f91cadecc03be93d5f71e171101a6aa58bbb881b0a4bb50a178"
  end

  head do
    url "https://github.com/erlang/otp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "wxwidgets@3.2" # for GUI apps like observer

  uses_from_macos "libxslt" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  resource "html" do
    url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-28.3.2/otp_doc_html_28.3.2.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_28.3.2.tar.gz"
    sha256 "58528081f585d611c98716f3b4f5ad0f86854163295e6ac04e317c7e1c1623e1"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://ghfast.top/https://github.com/elixir-lang/ex_doc/releases/download/v0.38.1/ex_doc_otp_27"
    sha256 "4aaafd13d056aeeca8b23a016b330114947c8d33ea657c22f637259e626e701e"
  end

  def install
    ex_doc_url = (buildpath/"make/ex_doc_link").read.strip
    odie "`ex_doc` resource needs updating!" if ex_doc_url != resource("ex_doc").url
    odie "html resource needs to be updated" if version != resource("html").version

    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligible error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" unless File.exist? "configure"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    args = %W[
      --enable-dynamic-ssl-lib
      --with-odbc=#{Formula["unixodbc"].opt_prefix}
      --with-ssl=#{Formula["openssl@3"].opt_prefix}
      --without-javac
      --with-wx-config=#{wx_config}
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll"
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    # The definition of `WX_CC` does not use our configuration of `--with-wx-config`, unfortunately.
    inreplace "lib/wx/configure", "WX_CC=`wx-config --cc`", "WX_CC=`#{wx_config} --cc`"

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
    resource("ex_doc").stage do |r|
      (buildpath/"bin").install File.basename(r.url) => "ex_doc"
    end
    chmod "+x", "bin/ex_doc"

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "install-docs", "DOC_TARGETS=chunks man" }

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
    system bin/"erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"

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