class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-29.1.1/otp_src_29.1.1.tar.gz"
  sha256 "054e0143e39c780e091107fc9b345792a9c1a55f6bac1eca1c1101510fc06bf6"
  license "Apache-2.0"
  compatibility_version 2

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f833857e036bbb282f66d0c6f32832a0c1bba34aebac69a9d875c2c83eae5b2e"
    sha256 cellar: :any, arm64_tahoe:       "7e37a31ec5ea62c77dc3d412c9538d7e5aec68ca3b1b9b60b8d899799f29f60f"
    sha256 cellar: :any, arm64_sequoia:     "909c13cd05f6c65d10e785b216787c73fd881b6ef00435bd77f4f99f5ac197c3"
    sha256 cellar: :any, arm64_linux:       "0ba5303137461782efa9f2880a1375a17eca40f0260ac81a3de2350943687626"
    sha256 cellar: :any, x86_64_linux:      "4f4938eee0a6126766d8b7dccc4fb8ef551639e7f67fda67d05d1437e4c4f2fc"
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
    url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-29.1.1/otp_doc_html_29.1.1.tar.gz"
    sha256 "3cdde911635fdf305d55c86302ded2eb8c6e3559d98e6adfbc4516b320b281a3"

    livecheck do
      formula :parent
    end
  end

  # https://github.com/erlang/otp/blob/OTP-#{version}/make/ex_doc_link
  resource "ex_doc" do
    url "https://ghfast.top/https://github.com/elixir-lang/ex_doc/releases/download/v0.40.4/ex_doc_otp_28"
    version "0.40.4/ex_doc_otp_28"
    sha256 "118ba88f04a1bedf665d34f3c1f6312c6d28fcbea34bb1166c74c54339e02b69"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/erlang/otp/refs/tags/OTP-#{LATEST_VERSION}/make/ex_doc_link"
      regex(%r{/v?(\d+(?:\.\d+)+/ex_doc_otp_\d+)$}i)
    end
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
      --with-odbc=#{formula_opt_prefix("unixodbc")}
      --with-ssl=#{formula_opt_prefix("openssl@3")}
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

    (testpath/"factorial").write <<~ERLANG
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
    ERLANG

    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end