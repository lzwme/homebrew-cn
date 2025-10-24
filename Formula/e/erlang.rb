class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-28.1.1/otp_src_28.1.1.tar.gz"
  sha256 "03e1b26e846b2cc1b49271656da6d5ecf4d5f4c2e34224d869a23c61a3d5660a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "39d5f145b5aa4ae0487bf59f00b6abfa30c9ac6bdca24fce85d3d8b77eb06759"
    sha256 cellar: :any,                 arm64_sequoia: "cc0b9a4dd139b9d4a2e8e6b7e9485ef2aa5ffc5c4394091213cd71e43e02887a"
    sha256 cellar: :any,                 arm64_sonoma:  "b0d849bddd55b795a3c59f8ef4e09b1bf5489c2edd050cfd25708187dcca289f"
    sha256 cellar: :any,                 sonoma:        "f91692ab9db3b0fbb1bef48577254f7bdaf3eca5309d4324280e723b35578a38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b714aa7736f2cbda9c2fa68d4b862f2c2c8db9c5b620a29eccabebf943f3db34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562056102144b2c367fb5cf6e8cd04055b5fc0a74fd1f5708059ce3acaa79f8e"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  resource "html" do
    url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-28.1.1/otp_doc_html_28.1.1.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_28.1.1.tar.gz"
    sha256 "d54bcc53b8ed0537d5595fca06beba5b3220b869aaeab41c1a40d9a21af892c7"

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