class ErlangAT26 < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  # Don't forget to update the documentation resource along with the url!
  url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-26.2.5.17/otp_src_26.2.5.17.tar.gz"
  sha256 "667d2f2c56b769d43ce3661fd941d5a30b03d7a060857a4a2ff5deef90666969"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^OTP[._-]v?(26(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5d27eca9e0b2e503d56579c002f5b249fc334ca4a2eba7d197536e216379fe5b"
    sha256 cellar: :any,                 arm64_sequoia: "ce83e5619bc4f0c1a69a0530703f789289b05bd8653247f2ac8b01259d523255"
    sha256 cellar: :any,                 arm64_sonoma:  "93968a856499af755a3c77379b3832debb0050fc75b00466ab878149b59abefd"
    sha256 cellar: :any,                 sonoma:        "0cda0da009587fbd76c416e3e477593c8e03c5909b262a14dad69583b488f8ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d06b2a25eb7669a578a4fb2c7c0f83421c477f87e6de47baf61eb5d3d5ee83c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "378167e557de0ac6fae343169fda4086b00cba1082180ff470e6efb58a41b24c"
  end

  keg_only :versioned_formula

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
    url "https://ghfast.top/https://github.com/erlang/otp/releases/download/OTP-26.2.5.17/otp_doc_html_26.2.5.17.tar.gz"
    sha256 "627d3ad435dedf9989f2cf4ccce53fde38286986cc644a58939b48d617e8a48e"

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
    system "./otp_build", "autoconf" unless File.exist? "configure"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"

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

    # Build the doc chunks (manpages are also built by default)
    ENV.deparallelize { system "make", "docs", "DOC_TARGETS=chunks" }
    ENV.deparallelize { system "make", "install-docs" }

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